alias GangsServer.World

defmodule World.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(World.Registry, [[name: World.Registry]]),
      supervisor(World.Process.Supervisor, [[name: World.Process.Supervisor]]),
      worker(World.Manager, [[name: World.Manager]]),
      worker(World.Initializer, [[name: World.Initializer]]),
    ]

    supervise(children, strategy: :one_for_all)
  end

end
