alias GangsServer.Store
alias Store.Schema.WorldType

defmodule Store.Interactor.WorldType do
  import Ecto.Query

  def get_by_ref(ref_name) do
    query = from w in WorldType,
            where: w.ref_name == ^ref_name
    Store.Repo.one(query)
  end
end
