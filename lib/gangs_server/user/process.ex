alias GangsServer.{User, World, Message}

defmodule User.Process do
  use GenServer

  # TODO: handle user process exit

  def init(user) do
    {:ok, %{user: user, world_pid: nil}}
  end

  def handle_call(:disconnect, _from, %{world_pid: nil} = state) do
    # Drop disconnect when not attached to world
    {:reply, :ok, state}
  end
  def handle_call(:disconnect, _from, %{world_pid: world_pid} = state) do
    World.Process.user_exit(world_pid, state.user.id)
    {:reply, :ok, state}
  end

  def handle_call({:message, %Message.WorldCreate{key: key}}, _from, state) do
    new_state = state
    |> Map.put(:world_pid, World.Manager.create(key, state.user.id))
    {:reply, :ok, new_state}
  end
  def handle_call({:message, %Message.WorldJoin{key: key}}, _from, state) do
    new_state = state
    |> Map.put(:world_pid, World.Manager.user_enter(key, state.user.id))
    {:reply, :ok, new_state}
  end
  def handle_call({:message, _message}, _from, %{world_pid: nil} = state) do
    # Drop other messages when not attached to world
    {:reply, :ok, state}
  end
  def handle_call({:message, message}, _from, state) do
    World.Process.user_message(state.world_pid, message, state.user.id)
    {:reply, :ok, state}
  end

  #==============

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def disconnect(pid), do: GenServer.call(pid, :disconnect)
  def message(pid, message), do: GenServer.call(pid, {:message, message})
end
