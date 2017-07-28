alias GangsServer.Store

defmodule Store.Schema.User do
  use Store.Schema

  schema "users" do
    field :name, :string
    field :services, {:array, :string}
    timestamps()

    belongs_to :locale, Store.Schema.Locale,
      foreign_key: :locale_ref,
      references: :ref_name
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> Ecto.Changeset.cast(params, [:name, :services])
    |> Ecto.Changeset.validate_required([])
  end

  defimpl String.Chars do
    def to_string(user), do: "#User{name: #{user.name}}"
  end
end
