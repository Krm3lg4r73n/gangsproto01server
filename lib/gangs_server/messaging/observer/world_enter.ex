alias GangsServer.{Messaging, Message}

defmodule Messaging.Observer.WorldEnter do
  def observe({:user_enter_world, world_id, user_id}) do
    {:ok, conn_pid} = Messaging.UserConnectionRegistry.translate_key(user_id)
    Messaging.ConnectionState.put(conn_pid, :world_id, world_id)
  end

  def observe({:user_enter_world_fail, user_id, reason}) do
    Message.Error.new(type: "ClientError", description: reason)
    |> Messaging.Message.send_to_user(user_id)
  end

  def observe(_), do: nil
end
