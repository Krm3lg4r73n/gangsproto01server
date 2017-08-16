alias GangsServer.Game

defmodule Game.World.Process.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(Game.World.Process, [], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
