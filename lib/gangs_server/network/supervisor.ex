alias GangsServer.Network

defmodule Network.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      supervisor(Network.TCP.Connection.Supervisor, [[name: Network.TCP.Connection.Supervisor]]),
      supervisor(Network.Websocket.Connection.Supervisor, [[name: Network.Websocket.Connection.Supervisor]]),
      worker(Network.ConnectionMonitor, [[name: Network.ConnectionMonitor]]),
      worker(Task, [Network.TCP.Server, :listen, [4040]], id: :tcp_server),
      worker(Task, [Network.Websocket.Server, :listen, [8080]], id: :websocket_server),
    ]

    supervise(children, strategy: :one_for_all)
  end
end
