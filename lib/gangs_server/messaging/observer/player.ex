alias GangsServer.{Messaging, Message}

defmodule Messaging.Observer.Player do
  def observe({:user_missing_player, user_id}) do
    Message.PlayerCreateRequest.new()
    |> Messaging.Message.send_to_user(user_id)
  end

  def observe({:player_create, player}) do
    Message.PlayerUpdate.new(name: player.name)
    |> Messaging.Message.send_to_user(player.user_id)
  end

  def observe({:player_create_fail, user_id, reason}) do
    Message.Error.new(type: "ClientError", description: reason)
    |> Messaging.Message.send_to_user(user_id)
  end

  def observe({:user_attach_to_player, player}) do
    Message.PlayerUpdate.new(name: player.name)
    |> Messaging.Message.send_to_user(player.user_id)
  end

  def observe(_), do: nil
end
