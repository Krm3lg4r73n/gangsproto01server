alias GangsServer.{Game, Store}

defmodule Game.Initializer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    start_world_processes()
    {:ok, nil}
  end

  defp start_world_processes() do
    Store.Interactor.World.get_all()
    |> Enum.each(&start_world(&1))
  end

  defp start_world(world) do
    {:ok, pid} = Supervisor.start_child(
                  Game.World.Process.Supervisor,
                  [world])
    Game.World.Registry.register(world.key, pid)
  end
end
