alias GangsServer.Store

defmodule Store.Schema.SceneEvent do
  use Store.Schema

  schema "scene_events" do
    field :ref_name, :string
    field :content_line, :string
    field :trigger_after, :integer
    timestamps()

    belongs_to :scene, Schema.Scene,
      foreign_key: :scene_ref,
      references: :ref_name
  end
end
