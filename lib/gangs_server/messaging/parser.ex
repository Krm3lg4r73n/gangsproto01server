alias GangsServer.{Messaging, Message}

defmodule Messaging.Parser do
  def parse(type, data) do
    message = Messaging.Dictionary.translate_type(type)
    data
    |> message.decode
    |> Messaging.Handler.handle
  end
end
