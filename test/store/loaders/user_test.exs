alias GangsServer.Store

defmodule Store.Loaders.UserTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Store.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Store.Repo, {:shared, self()})
    {:ok, %{value: :x}}
  end

  defp write_user(name) do
    %Store.Schemas.User{name: name}
    |> Store.Repo.insert!(returning: true)
  end

  test "it can load a user by name", %{value: val} do
    ["Frank", "Sammy", "Dean"]
    |> Enum.map(&write_user/1)
    #TODO move insert in setup

    assert Store.Loaders.User.load_user_by_name("Frank").name == "Frank"
  end
end
