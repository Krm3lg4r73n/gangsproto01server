require Logger
alias GangsServer.{Messaging, World, Message, Util}

defmodule Messaging.Handler.World do
  def handle(:connect, state) do
    {:cont, Map.put(state, :world_pid, nil)}
  end

  def handle({:message, %Message.WorldCreate{key: key}}, state) do
    case World.Creator.create(key) do
      {:ok, world} ->
        world_pid = start_process(world)
        World.Process.user_enter(world_pid, state.user_id)
        {:halt, %{state | world_pid: world_pid}}
      {:error, reason} ->
        Util.send_conn_error(state.conn_pid, reason)
        {:halt, state}
    end
  end
  def handle({:message, %Message.WorldJoin{key: key}}, state) do
    case World.Registry.translate_key(key) do
      {:ok, world_pid} ->
        World.Process.user_enter(world_pid, state.user_id)
        {:halt, %{state | world_pid: world_pid}}
      :error ->
        Util.send_conn_error(state.conn_pid, "World unknown")
        {:halt, state}
    end
  end
  def handle({:message, _}, %{world_pid: nil} = state) do
    # Drop other messages when not attached to world
    {:halt, state}
  end
  def handle({:message, message}, state) do
    World.Process.user_message(state.world_pid, message, state.user_id)
    {:cont, state}
  end

  def handle(:disconnect, %{world_pid: nil} = state) do
    # Drop disconnect when not attached to world
    {:halt, state}
  end
  def handle(:disconnect, state) do
    World.Process.user_exit(state.world_pid, state.user_id)
    {:cont, state}
  end

  def handle(_, state), do: {:cont, state}

  defp start_process(world) do
    {:ok, world_pid} = Supervisor.start_child(
      World.Process.Supervisor,
      [world])
    World.Registry.register(world.key, world_pid)
    world_pid
  end
end
