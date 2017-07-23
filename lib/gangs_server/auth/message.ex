alias GangsServer.{Auth, Messaging}

defmodule Auth.Message do
  defstruct [:message, :user]

  def send(%Auth.Message{message: message, user: user}) do
    conn = Auth.Dictionary.translate_user(user)
    %Messaging.Message{message: message, conn: conn}
    |> Messaging.Message.send
  end
end
