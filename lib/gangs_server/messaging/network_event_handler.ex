alias GangsServer.Messaging

defmodule Messaging.NetworkEventHandler do
  def handle({:message, message}, conn_state) do
    proto_msg = Messaging.ProtoParser.parse(message.type, message.data)
    Messaging.Pipeline.handle({:message, proto_msg}, conn_state)
  end
  def handle(event, conn_state), do: Messaging.Pipeline.handle(event, conn_state)
end
