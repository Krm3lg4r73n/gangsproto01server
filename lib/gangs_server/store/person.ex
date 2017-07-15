alias GangsServer.Store

defmodule Store.Person do
  use Ecto.Schema

  schema "people" do
    field :name, :string
    timestamps()
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> Ecto.Changeset.cast(params, [:name])
    |> Ecto.Changeset.validate_required([:name])
  end
end
