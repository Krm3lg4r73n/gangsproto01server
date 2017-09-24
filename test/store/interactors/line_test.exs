alias GangsServer.Store

defmodule Store.Interactor.LineTest do
  use ExUnit.Case, async: true
  alias Store.Interactor.Line, as: Subject

  setup do
    db = DBHelper.seed_and_sandbox()
    {:ok, %{db: db}}
  end

  describe "#localize" do
    @tag :wip
    test "it localizes a line", %{db: db} do
      local_name = Subject.localize(db.users.usr0.id, db.locations.wlt0_loc0.name_line)
      assert local_name == "Die erste Location."
    end
  end
end
