alias GangsServer.Game

defmodule Game.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(Game.Initializer, [[name: Game.Initializer]]),
    ]

    supervise(children, strategy: :rest_for_one)
  end

end
