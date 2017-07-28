alias GangsServer.Store

defmodule Store.Loader.User do
  import Ecto.Query

  def load_user_by_name(name) do
    query = from u in Store.Schema.User,
            where: u.name == ^name,
            preload: :locale
    Store.Repo.one(query)
  end
end
