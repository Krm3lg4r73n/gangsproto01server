alias GangsServer.{Messaging, TCP}

defmodule Messaging.Message do
  defstruct [:message, :conn]

  def send(%Messaging.Message{message: message, conn: conn}) do
    data = message.__struct__.encode(message)
    type = Messaging.Dictionary.translate_message(message)
    %TCP.Message{conn: conn, type: type, data: data}
    |> TCP.Message.send
  end
end
