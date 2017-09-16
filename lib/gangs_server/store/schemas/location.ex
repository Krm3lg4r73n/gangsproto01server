alias GangsServer.Store

defmodule Store.Schema.Location do
  use Store.Schema

  schema "locations" do
    field :ref_name, :string
    field :name_line, :string
    timestamps()

    belongs_to :world_type, Schema.WorldType,
      foreign_key: :world_type_ref,
      references: :ref_name
  end
end
