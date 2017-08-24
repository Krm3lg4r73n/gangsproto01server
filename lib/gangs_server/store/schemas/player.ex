alias GangsServer.Store

defmodule Store.Schema.Player do
  use Store.Schema

  schema "players" do
    field :name, :string
    timestamps()

    belongs_to :user, Store.Schema.User, type: :integer
    belongs_to :world, Store.Schema.World, type: :integer
  end

  def changeset(data, params \\ %{}) do
    data
    |> Ecto.Changeset.cast(params, [:name, :user_id, :world_id])
    |> Ecto.Changeset.unique_constraint(:name)
    |> Ecto.Changeset.assoc_constraint(:user)
    |> Ecto.Changeset.assoc_constraint(:world)
  end

  defimpl String.Chars do
    def to_string(world), do: "#World{key: #{world.key}}"
  end
end
