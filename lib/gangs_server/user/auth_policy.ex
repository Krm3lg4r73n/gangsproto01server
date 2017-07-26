alias GangsServer.{User, Store}

defmodule User.AuthPolicy do
  def verify(name) do
    name
    |> user_in_db
    |> format
  end

  defp user_in_db(name) do
    Store.Repo.get_by(Store.Schemas.User, name: name)
  end

  defp format(nil), do: :error
  defp format(user), do: {:ok, user}
end
