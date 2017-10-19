alias GangsServer.GameSystem

defmodule GameSystem.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      supervisor(GameSystem.Scene.Supervisor, [[name: GameSystem.Scene.Supervisor]]),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
