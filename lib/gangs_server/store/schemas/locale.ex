alias GangsServer.Store

defmodule Store.Schemas.Locale do
  use Store.Schema

  schema "locales" do
    field :ref_name, :string
    field :name, :string
    timestamps()
  end
end
