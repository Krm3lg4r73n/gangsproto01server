alias GangsServer.Store.Interactor.User

defmodule Store.Interactor.UserTest do
  use ExUnit.Case, async: true

  setup do
    db = DBHelper.seed_and_sandbox()
    {:ok, %{db: db}}
  end

  test "it can load a user by name" do
    assert User.get_by_name("User0").name == "User0"
  end

  test "it preloads the locale assoc", %{db: db} do
    assert User.get_by_name("User0").locale.name == db.locale.name
  end
end
