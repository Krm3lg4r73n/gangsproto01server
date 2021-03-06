alias GangsServer.World

defmodule World.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(World.State, [[name: World.State]]),
    ]
    supervise(children, strategy: :one_for_one)
  end
end
