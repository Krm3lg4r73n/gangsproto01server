alias GangsServer.Store

defmodule Store.Schema.WorldType do
  use Store.Schema

  schema "world_types" do
    field :ref_name, :string
    field :description_line, :string
    timestamps()
  end
end
