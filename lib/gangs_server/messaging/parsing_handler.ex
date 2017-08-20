require Logger
alias GangsServer.Messaging

defmodule Messaging.ParsingHandler do
  use GenEvent

  @target GangsServer.User.Manager

  def handle_event({:message, message}, _state) do
    proto_msg = Messaging.ProtoParser.parse(message.type, message.data)
    @target.message(message.conn, proto_msg)
    {:ok, nil}
  end
  def handle_event({:connect, conn}, _state) do
    @target.connect(conn)
    {:ok, nil}
  end
  def handle_event({:disconnect, conn}, _state) do
    @target.disconnect(conn)
    {:ok, nil}
  end
end
