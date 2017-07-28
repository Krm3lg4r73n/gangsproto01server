alias GangsServer.Store

defmodule Store.Schema.Line do
  use Store.Schema

  schema "lines" do
    field :key, :string
    field :text, :string
    timestamps()

    belongs_to :locale, Schema.Locale,
      foreign_key: :locale_ref,
      references: :ref_name
  end
end
