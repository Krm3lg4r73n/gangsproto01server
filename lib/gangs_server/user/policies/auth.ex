alias GangsServer.{User, Store}

defmodule User.Policy.Auth do
  def verify(name) do
    name
    |> user_in_db
    |> format
  end

  defp user_in_db(name) do
    Store.Loader.User.load_user_by_name(name)
  end

  defp format(nil), do: :error
  defp format(user), do: {:ok, user}
end
