require Logger
alias GangsServer.{Game, Message, Util}

defmodule Game.UserSystem.World do
  def handle_message(%Message.WorldCreate{key: key}, _world_pid) do
    case Game.World.Creator.create(key) do
      {:ok, _world} -> handle_enter_request(key)
      {:error, reason} ->
        Util.send_client_error(self(), reason)
        nil
    end
  end
  def handle_message(%Message.WorldJoin{key: key}, _world_pid) do
    handle_enter_request(key)
  end
  def handle_message(_message, world_pid), do: world_pid

  def handle_attach(), do: nil

  def handle_detach(world_pid) do
    IO.inspect(world_pid)
    unless is_nil(world_pid) do
      Game.World.Process.user_leave(world_pid, self())
    end
  end

  def handle_enter_request(key) do
    case Game.World.Registry.translate_key(key) do
      :error ->
        Util.send_client_error(self(), "World not found")
        nil
      {:ok, world_pid} ->
        Game.World.Process.user_enter(world_pid, self())
        world_pid
    end
  end
end
