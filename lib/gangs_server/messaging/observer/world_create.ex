alias GangsServer.{Messaging, Message}
alias GangsServer.GlobalEventManager, as: GEM

defmodule Messaging.Observer.WorldCreate do
  def observe({:world_create, world, user_id}) do
    GEM.invoke{:user_enter_world_req, user_id, world.key}
  end

  def observe({:world_create_fail, user_id, reason}) do
    Message.Error.new(type: "ClientError", description: reason)
    |> Messaging.Message.send_to_user(user_id)
  end

  def observe(_), do: nil
end
