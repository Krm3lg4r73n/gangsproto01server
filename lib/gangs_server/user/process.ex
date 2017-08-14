alias GangsServer.User

defmodule User.Process do
  use GenServer

  defstruct user: nil, systems: []

  def init(user) do
    {:ok, %User.Process{user: user}}
  end

  def handle_call({:message, message}, _from, state) do
    state.systems |> Enum.each(&(&1.handle_message(message, self())))
    {:reply, :ok, state}
  end
  def handle_call({:attach_to_system, system}, _from, state) do
    system.handle_attach(self())
    {:reply, :ok, %{state | systems: [system | state.systems]}}
  end
  def handle_call(:disconnect, _from, state) do
    state.systems |> Enum.each(&(&1.handle_detach(self())))
    {:reply, :ok, state}
  end

  #==============

  def start_link(state, opts \\ []), do: GenServer.start_link(__MODULE__, state, opts)
  def disconnect(pid), do: GenServer.call(pid, :disconnect)
  def handle_message(pid, message), do: GenServer.call(pid, {:message, message})
  def attach_to_system(pid, system), do: GenServer.call(pid, {:attach_to_system, system})
end
