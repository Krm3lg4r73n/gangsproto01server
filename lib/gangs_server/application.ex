alias GangsServer.{TCP, Store}

defmodule GangsServer.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(TCP.Supervisor, [[name: TCP.Supervisor]]),
      supervisor(Store.Supervisor, [[name: Store.Supervisor]]),
    ]

    opts = [strategy: :one_for_one, name: GangsServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
