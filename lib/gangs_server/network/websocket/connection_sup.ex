alias GangsServer.Network

defmodule Network.Websocket.Connection.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(Network.Websocket.Connection, [], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
