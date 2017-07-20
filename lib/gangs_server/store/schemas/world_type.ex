alias GangsServer.Store.Schemas

defmodule Schemas.WorldType do
  use Ecto.Schema

  schema "world_types" do
    field :ref_name, :string
    timestamps()

    belongs_to :description_line, Schemas.Line,
      foreign_key: :description_line_ref,
      references: :ref_name,
      type: :string
  end
end
