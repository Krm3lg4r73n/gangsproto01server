alias GangsServer.Store
alias Store.Schema.Location

defmodule Store.Interactor.Location do
  import Ecto.Query

  def all(_world_id) do
    []
  end

  def get_by_ref(ref_name) do
    query = from w in Location,
            where: w.ref_name == ^ref_name
    Store.Repo.one(query)
  end
end
