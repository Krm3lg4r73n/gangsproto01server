alias GangsServer.{World, Store, Util}

defmodule World.Creator do
  def create(key) do
    world_type = Store.Interactor.WorldType.get_by_ref("new_earth")
    case Store.Interactor.World.create(world_type, key) do
      {:ok, world} -> {:ok, world}
      {:error, changeset} -> {:error, Util.stringify_changeset_errors(changeset)}
    end
  end
end
