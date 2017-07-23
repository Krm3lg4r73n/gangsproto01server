require Logger
alias GangsServer.Messaging

defmodule Messaging.ParsingHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    proto_msg = Messaging.ProtoParser.parse(message.type, message.data)
    %Messaging.Message{message: proto_msg, conn: message.conn}
    |> Messaging.EventManager.fire_message
    {:ok, nil}
  end

  def handle_event(event, _state) do
    Messaging.EventManager.refire(event)
    {:ok, nil}
  end
end
