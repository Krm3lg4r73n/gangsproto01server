alias GangsServer.Game

defmodule Game.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(Game.World.Registry, [[name: Game.World.Registry]]),
      supervisor(Game.World.Process.Supervisor, [[name: Game.World.Process.Supervisor]]),
      worker(Game.Initializer, [[name: Game.Initializer]]),
    ]

    supervise(children, strategy: :one_for_all)
  end

end
