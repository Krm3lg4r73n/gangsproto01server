require Logger
alias GangsServer.{GameSystem, User, Message, Store, Util}

defmodule GameSystem.Player do
  def user_enter(user_id, world_id) do
    case Store.Interactor.Player.get(user_id, world_id) do
      nil -> send_request(user_id)
      player -> send_update(user_id, player)
    end
  end

  def user_message(%Message.PlayerCreate{} = message, user_id, world_id) do
    case Store.Interactor.Player.create(user_id, world_id, message.name) do
      {:ok, player} -> send_update(user_id, player)
      {:error, changeset} ->
        Util.send_user_error(user_id,
                             Util.stringify_changeset_errors(changeset))
    end
  end
  def user_message(_, _, _), do: nil

  defp send_update(user_id, player) do
    Message.PlayerUpdate.new(name: player.name)
    |> User.Message.send(user_id)
  end

  defp send_request(user_id) do
    Message.PlayerCreateRequest.new()
    |> User.Message.send(user_id)
  end
end
