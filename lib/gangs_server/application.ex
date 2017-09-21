alias GangsServer.{Network, Store, Messaging, User, World}

defmodule GangsServer.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Store.Supervisor, [[name: Store.Supervisor]]),
      supervisor(Network.Supervisor, [[name: Network.Supervisor]]),
      supervisor(Messaging.Supervisor, [[name: Messaging.Supervisor]]),
      supervisor(User.Supervisor, [[name: User.Supervisor]]),
      supervisor(World.Supervisor, [[name: World.Supervisor]]),
      worker(GangsServer.GlobalEventManager, [[name: GangsServer.GlobalEventManager]]),
    ]

    opts = [strategy: :one_for_one, name: GangsServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
