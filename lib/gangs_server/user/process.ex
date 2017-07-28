alias GangsServer.{User, Message, Game}

defmodule User.Process do
  use GenServer

  defstruct user: nil, systems: []

  def init(user) do
    {:ok, %User.Process{user: user}}
  end

  def handle_call({:message, message}, _from, state) do
    on_message(message, state)
    {:reply, :ok, state}
  end
  def handle_call({:attach_system, system}, _from, state) do
    {:reply, :ok, %{state | systems: [system | state.systems]}}
  end

  defp on_message(%Message.WorldCreate{key: key}, _state) do
    Game.WorldManager.create_world(key)
  end
  defp on_message(%Message.WorldJoin{key: key}, _state) do
    Game.WorldManager.join_world(key)
  end
  defp on_message(message, state) do
    state.systems
    |> Enum.each(fn system ->
      system.handle_message(message)
    end)
  end

  #==============

  def start_link(state, opts \\ []), do: GenServer.start_link(__MODULE__, state, opts)
  def disconnect(pid), do: GenServer.call(pid, :disconnect)
  def handle_message(pid, message), do: GenServer.call(pid, {:message, message})
  def attach_system(pid, system), do: GenServer.call(pid, {:attach_system, system})
end
