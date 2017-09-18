alias GangsServer.Network

defmodule Network.EventManager do

  @event_handler Application.get_env(:gangs_server, :network_event_handler)

  def fire_connect(conn_pid) do
    conn_state = @event_handler.handle(:connect, %{conn_pid: conn_pid})
    Network.ConnectionStateLookup.put(conn_pid, conn_state)
  end

  def fire_disconnect(conn_pid) do
    conn_state = Network.ConnectionStateLookup.lookup(conn_pid)
    @event_handler.handle(:disconnect, conn_state)
    Network.ConnectionStateLookup.drop(conn_pid)
  end

  def fire_message(conn_pid, message) do
    conn_state = Network.ConnectionStateLookup.lookup(conn_pid)
    conn_state = @event_handler.handle({:message, message}, conn_state)
    Network.ConnectionStateLookup.put(conn_pid, conn_state)
  end
end
