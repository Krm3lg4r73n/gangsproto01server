require Logger
alias GangsServer.Network

defmodule Network.TCP.Server do
  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(
      port,
      [:binary, {:packet, 0}, ip: {0,0,0,0}, active: true, reuseaddr: true])
    Logger.info "Network.Health.Server listening on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info "Health connection #{client}"
    loop_acceptor(socket)
  end
end
