alias GangsServer.{Messaging, Message, Store}

defmodule Messaging.Observer.Location do
  def observe({:player_enter_location, player, location}) do
    send_update(player.user_id, location)
  end

  def observe({:user_init_location, user_id, location}) do
    send_update(user_id, location)
  end

  def observe(_), do: nil

  defp send_update(user_id, location) do
    Message.LocationUpdate.new(
      name: Store.Interactor.Line.localize(user_id, location.name_line))
    |> Messaging.Message.send_to_user(user_id)
  end
end
