alias GangsServer.User

defmodule User.Process do
  use GenServer

  defstruct user: nil, systems: %{}

  def init(user) do
    {:ok, %User.Process{user: user}}
  end

  def handle_call({:message, message}, _from, state) do
    new_systems = state.systems
    |> Enum.reduce(state.systems, fn elem, systems ->
      system_handle_message(elem, systems, message)
    end)
    {:reply, :ok, %{state | systems: new_systems}}
  end
  def handle_call({:attach_system, system}, _from, state) do
    system_state = system.handle_attach()
    new_systems = Map.put(state.systems, system, system_state)
    {:reply, :ok, %{state | systems: new_systems}}
  end
  def handle_call(:disconnect, _from, state) do
    state.systems
    |> Enum.each(&system_handle_detach/1)
    {:reply, :ok, state}
  end

  defp system_handle_message({system, sys_state}, systems, message) do
    new_sys_state = system.handle_message(message, sys_state)
    Map.put(systems, system, new_sys_state)
  end

  defp system_handle_detach({system, sys_state}) do
    system.handle_detach(sys_state)
  end

  #==============

  def start_link(state, opts \\ []), do: GenServer.start_link(__MODULE__, state, opts)
  def disconnect(pid), do: GenServer.call(pid, :disconnect)
  def handle_message(pid, message), do: GenServer.call(pid, {:message, message})
  def attach_system(pid, system), do: GenServer.call(pid, {:attach_system, system})
end
