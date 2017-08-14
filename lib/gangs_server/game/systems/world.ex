require Logger
alias GangsServer.{Game, Message, User, Store, Util}

defmodule Game.System.World do
  def handle_message(%Message.WorldCreate{key: key}, user_pid) do
    Logger.info "#{inspect(user_pid)} creating world #{key}"
    handle_create_request(user_pid, key)
  end
  def handle_message(%Message.WorldJoin{key: key}, user_pid) do
    Logger.info "#{inspect(user_pid)} joining world #{key}"
    handle_join_request(user_pid, key)
  end
  def handle_message(_message, _user_pid), do: nil

  def handle_attach(user_pid) do
    Logger.info "#{inspect(user_pid)} attached"
  end

  def handle_detach(user_pid) do
    Logger.info "#{inspect(user_pid)} detached"
  end

  defp handle_create_request(user_pid, key) do
    world_type = Store.Interactor.WorldType.get_by_ref("new_earth")
    case Store.Interactor.World.create(world_type, key) do
      {:ok, world} -> join_world(user_pid, world)
      {:error, changeset} -> send_error_message(
        user_pid, Util.stringify_changeset_errors(changeset))
    end
  end

  def handle_join_request(user_pid, key) do
    case Store.Interactor.World.get_by_key(key) do
      nil -> send_error_message(user_pid, "World not found")
      world -> join_world(user_pid, world)
    end
  end

  defp join_world(user_pid, world) do
    send_joined_message(user_pid, world.id)
  end

  defp send_joined_message(user_pid, world_id) do
    Message.WorldJoined.new(world_id: world_id)
    |> User.Message.send(user_pid)
  end

  defp send_error_message(user_pid, error_desc) do
    Message.Error.new(type: "ClientError", description: error_desc)
    |> User.Message.send(user_pid)
  end
end
