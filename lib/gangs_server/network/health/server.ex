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
    Logger.info "Health connection #{inspect(client)}"
    Task.start(fn -> 
      case :gen_tcp.recv(client, 0) do
        {:ok, data} -> Logger.info "Health received #{inspect(data)}"
        other -> 
      end
    end)
    loop_acceptor(socket)
  end
  defp serve_client(error), do: Logger.info "Error #{inspect(error)}"
end
