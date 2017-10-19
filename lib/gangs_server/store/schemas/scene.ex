alias GangsServer.Store

defmodule Store.Schema.Scene do
  use Store.Schema

  schema "scenes" do
    field :ref_name, :string
    field :name_line, :string
    field :is_opening, :boolean
    timestamps()

    belongs_to :location, Store.Schema.Location,
      foreign_key: :location_ref,
      references: :ref_name
  end
end
