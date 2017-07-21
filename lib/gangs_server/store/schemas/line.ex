alias GangsServer.Store

defmodule Store.Schemas.Line do
  use Store.Schema

  schema "lines" do
    field :key, :string
    field :text, :string
    timestamps()

    belongs_to :locale, Schemas.Locale,
      foreign_key: :locale_ref,
      references: :ref_name,
      type: :string
  end
end
