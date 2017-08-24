alias GangsServer.{User, Messaging}

defmodule User.Message do
  def send(message, user_id) do
    {:ok, conn} = User.UserRegistry.translate_key(user_id)
    message
    |> Messaging.Message.send(conn)
  end
end
