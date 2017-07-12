defmodule GangsServer.MessageParser do
  alias GangsServer.{MessageHandler, MessageDictionary}

  def parse(type, data) do
    message = MessageDictionary.translate_type(type)
    data
    |> message.decode
    |> MessageHandler.handle
  end
end
