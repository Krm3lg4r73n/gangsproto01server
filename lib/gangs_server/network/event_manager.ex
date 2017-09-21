alias GangsServer.Network

defmodule Network.EventManager do
  use GenServer

  @event_handler Application.get_env(:gangs_server, :network_event_handler)

  def fire_connect(conn_pid) do
    @event_handler.handle(:connect, conn_pid)
  end

  def fire_disconnect(conn_pid) do
    @event_handler.handle(:disconnect, conn_pid)
  end

  def fire_message(conn_pid, message) do
    @event_handler.handle({:message, message}, conn_pid)
  end
end
