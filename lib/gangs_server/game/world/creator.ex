alias GangsServer.{Game, Store, Util}

defmodule Game.World.Creator do
  def create(key) do
    with {:ok, world} <- create_in_store(key),
         {:ok, _world_pid} <- start_process(world),
         do: {:ok, world}
  end

  defp create_in_store(key) do
    world_type = Store.Interactor.WorldType.get_by_ref("new_earth")
    case Store.Interactor.World.create(world_type, key) do
      {:ok, world} -> {:ok, world}
      {:error, changeset} -> {:error, Util.stringify_changeset_errors(changeset)}
    end
  end

  defp start_process(world) do
    {:ok, world_pid} = Supervisor.start_child(
      Game.World.Process.Supervisor,
      [world])
    Game.World.Registry.register(world.key, world_pid)
    {:ok, world_pid}
  end
end
