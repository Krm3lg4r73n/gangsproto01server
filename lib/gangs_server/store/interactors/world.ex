alias GangsServer.Store
alias Store.Schema.World

defmodule Store.Interactor.World do
  import Ecto.Query

  def create(world_type, key) do
    Ecto.build_assoc(world_type, :worlds, key: key)
    |> Store.Schema.World.changeset()
    |> Store.Repo.insert()
  end

  def get_by_key(key) do
    query = from w in World,
            where: w.key == ^key
    Store.Repo.one(query)
  end
end
