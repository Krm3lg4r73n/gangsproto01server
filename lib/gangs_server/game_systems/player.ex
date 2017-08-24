require Logger
alias GangsServer.{GameSystem, User, Message, Store}

defmodule GameSystem.Player do
  def user_enter(user_id, world_id) do
    case Store.Interactor.Player.get(user_id, world_id) do
      nil -> send_request(user_id)
      player -> send_update(user_id, player)
    end
  end

  def user_message(%Message.PlayerCreate{} = message, _user_id, _world_id) do
    Logger.info "Creating player #{inspect(message)}"
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
