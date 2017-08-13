alias GangsServer.Store

defmodule Store.Interactor.World do
  def create(world_type, key) do
    Ecto.build_assoc(world_type, :worlds, key: key)
    |> Store.Schema.World.changeset()
    |> Store.Repo.insert()
  end
end
