alias GangsServer.Store.Schemas

defmodule Schemas.LocationEvent do
  use Ecto.Schema

  schema "location_events" do
    field :ref_name, :string
    timestamps()

    belongs_to :location, Schemas.Location,
      foreign_key: :location_ref,
      references: :ref_name,
      type: :string

    belongs_to :area_line, Schemas.Line,
      foreign_key: :area_line_ref,
      references: :ref_name,
      type: :string
  end
end
