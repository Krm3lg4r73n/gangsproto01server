alias GangsServer.Store

defmodule Store.Loaders.User do
  import Ecto.Query

  def load_user_by_name(name) do
    query = from u in Store.Schemas.User,
            where: u.name == ^name
    Store.Repo.one(query)
  end


end
