alias GangsServer.Store

defmodule Store.Schemas.LocationEvent do
  use Store.Schema

  schema "location_events" do
    field :ref_name, :string
    field :area_line, :string
    timestamps()

    belongs_to :location, Schemas.Location,
      foreign_key: :location_ref,
      references: :ref_name
  end
end
