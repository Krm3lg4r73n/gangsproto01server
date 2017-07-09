defmodule GangsServer.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(GangsServer.Connection.Supervisor,
                 [[name: GangsServer.Connection.Supervisor]]),
      worker(Task, [GangsServer, :accept, [4040]])
    ]

    opts = [strategy: :one_for_one, name: GangsServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
