alias GangsServer.Store
alias Store.Interactor.{Player, World}

defmodule Store.Interactor.PlayerTest do
  use ExUnit.Case, async: true

  setup do
    db = DBHelper.seed_and_sandbox()
    {:ok, world} = World.create(db.world_type, "key")
    {:ok, %{db: db, world: world}}
  end

  describe "#create" do
    test "it creates a new player", %{db: db, world: world} do
      {:ok, player} = Player.create(db.users.frank.id, world.id, "name")
      assert player.name == "name"
      assert player.user_id == db.users.frank.id
      assert player.world_id == world.id
    end
  end

  describe "#get" do
    @tag :wip
    test "it get a player", %{db: db, world: world} do
      {:ok, player} = Player.create(db.users.frank.id, world.id, "name")

      assert Player.get(db.users.frank.id, world.id) == player
    end
  end
end
