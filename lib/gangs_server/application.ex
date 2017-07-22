alias GangsServer.{TCP, Store, Messaging, Auth, Game}

defmodule GangsServer.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Store.Supervisor, [[name: Store.Supervisor]]),
      supervisor(TCP.Supervisor, [[name: TCP.Supervisor]]),
      supervisor(Messaging.Supervisor, [[name: Messaging.Supervisor]]),
      supervisor(Auth.Supervisor, [[name: Auth.Supervisor]]),
      supervisor(Game.Supervisor, [[name: Game.Supervisor]]),
    ]

    opts = [strategy: :one_for_one, name: GangsServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
