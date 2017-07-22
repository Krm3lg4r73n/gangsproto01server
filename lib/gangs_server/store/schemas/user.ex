alias GangsServer.Store

defmodule Store.Schemas.User do
  use Store.Schema

  schema "users" do
    field :name, :string
    timestamps()

    belongs_to :locale, Schemas.Locale,
      foreign_key: :locale_ref,
      references: :ref_name
  end

  defimpl String.Chars do
    def to_string(user), do: "#User{name: #{user.name}}"
  end
end
