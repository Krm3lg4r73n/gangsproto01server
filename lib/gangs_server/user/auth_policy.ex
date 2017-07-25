alias GangsServer.{User, Store}

defmodule User.AuthPolicy do
  def verify(name) do
    name
    |> user_in_db
  end

  defp user_in_db(name) do
    Store.Repo.get_by(Store.Schemas.User, name: name)
  end
end
