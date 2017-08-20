alias GangsServer.Store

defmodule Store.Schema.World do
  use Store.Schema

  schema "worlds" do
    field :key, :string
    timestamps()

    belongs_to :world_type, Store.Schema.WorldType, type: :integer
  end

  def changeset(data, params \\ %{}) do
    data
    |> Ecto.Changeset.cast(params, [:key])
    |> Ecto.Changeset.unique_constraint(:key)
    |> Ecto.Changeset.assoc_constraint(:world_type)
  end

  defimpl String.Chars do
    def to_string(world), do: "#World{key: #{world.key}}"
  end
end
