require Logger
alias GangsServer.{Game, Message, User}

defmodule Game.UserSystem.World do
  def handle_message(%Message.WorldCreate{key: key}, user_pid) do
    handle_create_request(user_pid, key)
  end
  def handle_message(%Message.WorldJoin{key: key}, user_pid) do
    handle_join_request(user_pid, key)
  end
  def handle_message(_message, _user_pid), do: nil

  def handle_attach(_user_pid), do: nil
  def handle_detach(_user_pid), do: nil

  defp handle_create_request(user_pid, key) do
    case Game.World.Creator.create(key) do
      {:ok, _world} -> handle_join_request(user_pid, key)
      {:error, reason} -> send_error_message(user_pid, reason)
    end
  end

  def handle_join_request(user_pid, key) do
    case Game.World.Registry.translate_key(key) do
      {:ok, world_pid} -> Game.World.Process.user_join(world_pid, user_pid)
      :error -> send_error_message(user_pid, "World not found")
    end
  end

  defp send_error_message(user_pid, error_desc) do
    Message.Error.new(type: "ClientError", description: error_desc)
    |> User.Message.send(user_pid)
  end
end
