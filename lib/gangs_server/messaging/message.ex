alias GangsServer.{Messaging, TCP}

defmodule Messaging.Message do
  defstruct [:message, :conn]

  def send(message, conn) do
    data = message.__struct__.encode(message)
    type = Messaging.Dictionary.translate_message(message)
    TCP.Message.send(type, data, conn)
  end
end
