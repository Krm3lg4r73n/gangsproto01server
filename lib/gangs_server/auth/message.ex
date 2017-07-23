alias GangsServer.{Auth, Messaging}

defmodule Auth.Message do
  defstruct [:message, :user]

  def send(message, user) do
    {:ok, conn} = Auth.Dictionary.translate_user(user)
    message
    |> Messaging.Message.send(conn)
  end
end
