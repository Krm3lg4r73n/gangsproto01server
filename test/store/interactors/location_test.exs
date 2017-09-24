alias GangsServer.Store
alias Store.Interactor.{Player, World}

defmodule Store.Interactor.LocationTest do
  use ExUnit.Case, async: true
  alias Store.Interactor.Location, as: Subject

  setup do
    db = DBHelper.seed_and_sandbox()
    {:ok, wld0} = World.create(db.world_type, "key")
    {:ok, plr0} = Player.create(db.users.usr0.id, wld0.id, "plr0")
    {:ok, %{db: db, wld0: wld0, plr0: plr0}}
  end

  describe "#get_by_ref" do
    test "it gets the location", %{db: db} do
      location = Subject.get_by_ref(db.locations.wlt0_loc0.ref_name)
      assert location == db.locations.wlt0_loc0
    end
  end

  describe "#all" do
    @tag :skip
    test "it gets all locations for a world", %{db: db, wld0: world} do
      assert Subject.all(world.id) == [db.locations.wlt0_loc0, db.locations.wlt0_loc1]
    end
  end
end
