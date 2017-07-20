alias GangsServer.Messaging

defmodule Messaging.Parser do
  def parse(type, data) do
    message = Messaging.Dictionary.translate_type(type)
    data
    |> message.decode
    |> Messaging.EventManager.fire
  end
end
