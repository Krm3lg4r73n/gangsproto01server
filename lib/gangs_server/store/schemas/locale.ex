alias GangsServer.Store.Schemas

defmodule Schemas.Locale do
  use Ecto.Schema

  schema "locales" do
    field :ref_name, :string
    field :name, :string
    timestamps()
  end

  # def changeset(schema, params \\ %{}) do
  #   schema
  #   |> Ecto.Changeset.cast(params, [:name])
  #   |> Ecto.Changeset.validate_required([:name])
  # end
end
