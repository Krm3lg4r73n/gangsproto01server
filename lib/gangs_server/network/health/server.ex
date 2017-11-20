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
   :gen_tcp.accept(socket)
   |> serve_client(socket)
  end

  defp serve_client({:ok, client}, socket) do
    Logger.debug "Health connection #{inspect(client)}"
    Task.start(fn -> 
      data = :gen_tcp.recv(client, 0)
      Logger.debug "Health receive for #{inspect(client)} #{inspect(data)}"
    end)
    loop_acceptor(socket)
  end
  defp serve_client(error), do: Logger.debug "Accept Error #{inspect(error)}"
end
