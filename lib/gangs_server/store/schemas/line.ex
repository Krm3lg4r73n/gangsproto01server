alias GangsServer.Store.Schemas

defmodule Schemas.Line do
  use Ecto.Schema

  schema "lines" do
    field :ref_name, :string
    field :text, :string
    timestamps()

    belongs_to :locale, Schemas.Locale,
      foreign_key: :locale_ref,
      references: :ref_name,
      type: :string
  end
end
