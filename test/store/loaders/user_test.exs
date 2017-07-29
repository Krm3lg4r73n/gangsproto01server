alias GangsServer.Store

defmodule Store.Loader.UserTest do
  use ExUnit.Case, async: true

  defp add_locale do
    %Store.Schema.Locale{ref_name: "de", name: "Deutsch"}
    |> Store.Repo.insert!
  end

  defp add_users do
    users = %{
      frank: %Store.Schema.User{name: "Frank", locale_ref: "de"},
    }
    users
    |> Enum.each(fn {_, user} -> Store.Repo.insert(user) end)
    users
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Store.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Store.Repo, {:shared, self()})

    add_locale()
    users = add_users()

    {:ok, %{users: users}}
  end

  test "it can load a user by name" do
    assert Store.Loader.User.load_user_by_name("Frank").name == "Frank"
  end

  test "it preloads the locale assoc" do
    assert Store.Loader.User.load_user_by_name("Frank").locale.name == "Deutsch"
  end
end
