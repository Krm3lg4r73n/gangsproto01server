alias GangsServer.Store
alias Store.Interactor.World

defmodule Store.Interactor.WorldTest do
  use ExUnit.Case, async: true

  setup do
    db = DBHelper.seed_and_sandbox()
    {:ok, %{db: db}}
  end

  test "it creates a new world", %{db: db} do
    {:ok, world} = World.create(db.world_type, "test-key")
    assert world.key == "test-key"
    assert world.world_type_id == db.world_type.id
  end

  test "it errors on unique constraint", %{db: db} do
    {:ok, _} = World.create(db.world_type, "test-key")
    {:error, changeset} = World.create(db.world_type, "test-key")
    assert Keyword.has_key?(changeset.errors, :key) == true
  end
end
