defmodule GangsServer.Store.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    # Game Data
    create table(:locales) do
      add :ref_name, :string, null: false
      add :name, :string, null: false
      timestamps()
    end
    create index(:locales, [:ref_name], unique: true)

    create table(:lines) do
      add :locale_ref, references(:locales, column: :ref_name, type: :string, on_delete: :delete_all)
      add :key, :string, null: false
      add :text, :string, null: false
      timestamps()
    end
    create index(:lines, [:key, :locale_ref], unique: true)

    create table(:world_types) do
      add :ref_name, :string, null: false
      add :description_line, :string, null: false
      timestamps()
    end
    create index(:world_types, [:ref_name], unique: true)

    create table(:locations) do
      add :ref_name, :string, null: false
      add :world_type_ref, references(:world_types, column: :ref_name, type: :string, on_delete: :delete_all)
      add :name_line, :string, null: false
      timestamps()
    end
    create index(:locations, [:ref_name], unique: true)

    create table(:scenes) do
      add :ref_name, :string, null: false
      add :location_ref, references(:locations, column: :ref_name, type: :string, on_delete: :delete_all)
      add :is_opening, :boolean, null: false, default: false
      timestamps()
    end
    create index(:scenes, [:ref_name], unique: true)

    create table(:scene_events) do
      add :ref_name, :string, null: false
      add :scene_ref, references(:scenes, column: :ref_name, type: :string, on_delete: :delete_all)
      add :content_line, :string, null: false
      add :trigger_after, :integer, null: false
      timestamps()
    end
    create index(:scene_events, [:ref_name], unique: true)

    # Instance Data
    create table(:users) do
      add :name, :string, null: false
      add :services, {:array, :string}, null: false, default: []
      add :locale_ref, references(:locales, column: :ref_name, type: :string, on_delete: :nilify_all)
      timestamps()
    end
    create index(:users, [:name], unique: true)

    create table(:worlds) do
      add :key, :string, null: false
      add :world_type_id, references(:world_types, on_delete: :delete_all)
      timestamps()
    end
    create index(:worlds, [:key], unique: true)

    create table(:players) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :nilify_all)
      add :world_id, references(:worlds, on_delete: :delete_all)
      timestamps()
    end
    create index(:players, [:name, :world_id], unique: true)
    create index(:players, [:user_id, :world_id], unique: true)

    # State Data
    create table(:location_records) do
      add :player_id, references(:players, on_delete: :delete_all)
      add :location_ref, references(:locations, column: :ref_name, type: :string)
      timestamps()
    end

    create table(:scene_records) do
      add :player_id, references(:players, on_delete: :delete_all)
      add :scene_ref, references(:scenes, column: :ref_name, type: :string)
      timestamps()
    end
  end
end
