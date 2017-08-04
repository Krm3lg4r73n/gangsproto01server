require Logger
alias GangsServer.Network

defmodule Network.Websocket.Server do
  def listen(port) do
    {:ok, socket} = Socket.Web.listen(
      port,
      mode: :active, local: [address: "0.0.0.0"])
    Logger.info "Network.Websocket.Server listening on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = Socket.Web.accept(socket)
    {:ok, pid} = Supervisor.start_child(
      Network.Websocket.Connection.Supervisor,
      [client])
    Process.register(pid, :conn)
    :ok = Network.ConnectionMonitor.monitor(pid)
    loop_acceptor(socket)
  end
end
