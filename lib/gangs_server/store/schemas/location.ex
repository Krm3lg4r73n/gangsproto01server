alias GangsServer.Store.Schemas

defmodule Schemas.Location do
  use Ecto.Schema

  schema "locations" do
    field :ref_name, :string
    timestamps()

    belongs_to :world_type, Schemas.WorldType,
      foreign_key: :world_type_ref,
      references: :ref_name,
      type: :string

    belongs_to :name_line, Schemas.Line,
      foreign_key: :name_line_ref,
      references: :ref_name,
      type: :string

    belongs_to :area_line, Schemas.Line,
      foreign_key: :area_line_ref,
      references: :ref_name,
      type: :string
  end
end
