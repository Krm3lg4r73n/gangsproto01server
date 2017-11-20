require Logger
alias GangsServer.Network

defmodule Network.Health.Server do
  def listen(port) do
    {:ok, socket} = :gen_tcp.listen(
      port,
      [:binary, {:packet, 0}, ip: {0,0,0,0}, active: false, reuseaddr: true])
    Logger.info "Network.Health.Server listening on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info "Health connection #{inspect(client)}"
    Task.start(fn -> 
      {:ok, data} = :gen_tcp.recv(client, 0)
      Logger.info "Health received #{inspect(data)}"
    end)
    loop_acceptor(socket)
  end
end
