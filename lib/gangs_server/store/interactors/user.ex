alias GangsServer.Store
alias Store.Schema.User

defmodule Store.Interactor.User do
  import Ecto.Query

  def get_by_id(id) do
    Store.Repo.get(User, id)
  end

  def get_by_name(name) do
    query = from u in User,
            where: u.name == ^name,
            preload: :locale
    Store.Repo.one(query)
  end
end
