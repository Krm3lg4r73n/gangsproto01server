require Logger
alias GangsServer.Network

defmodule Network.TCP.Server do
  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(
      port,
      [:binary, {:packet, 0}, ip: {0,0,0,0}, active: true, reuseaddr: true])
    Logger.info "Network.TCP.Server listening on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Supervisor.start_child(
      Network.TCP.Connection.Supervisor,
      [client])
    :ok = Network.ConnectionMonitor.monitor(pid)
    :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end
end
