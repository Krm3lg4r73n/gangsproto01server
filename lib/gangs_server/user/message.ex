alias GangsServer.{User, Messaging}

defmodule User.Message do
  def send(message, user) do
    {:ok, conn} = User.Registry.translate_user(user)
    message
    |> Messaging.Message.send(conn)
  end
end
