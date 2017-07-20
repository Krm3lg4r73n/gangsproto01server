defmodule GangsServer.Store.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    # AdminData
    create table(:users) do
      add :name, :string, null: false
      add :locale_ref ,:string, null: false
      timestamps()
    end
    create index(:users, [:name], unique: true)

    # InstanceData
    create table(:worlds) do
      add :ref_name, :string, null: false
      add :world_type_id, :integer, null: false
      timestamps()
    end
    create index(:worlds, [:ref_name], unique: true)

    create table(:players) do
      add :name, :string, null: false
      add :user_id, :integer, null: false
      add :world_id, :integer, null: false
      timestamps()
    end
    create index(:players, [:name, :world_id], unique: true)
    create index(:players, [:user_id, :world_id], unique: true)

    # GameData
    create table(:locales) do
      add :ref_name, :string, null: false
      add :name, :string, null: false
      timestamps()
    end
    create index(:locales, [:ref_name], unique: true)

    create table(:lines) do
      add :ref_name, :string, null: false
      add :locale_ref, :string, null: false
      add :text, :string, null: false
      timestamps()
    end
    create index(:lines, [:ref_name, :locale_ref], unique: true)

    create table(:world_types) do
      add :ref_name, :string, null: false
      add :description_line_ref, :string, null: false
      timestamps()
    end
    create index(:world_types, [:ref_name], unique: true)

    create table(:locations) do
      add :ref_name, :string, null: false
      add :world_type_ref, :string, null: false
      add :name_line_ref, :string, null: false
      add :area_line_ref, :string, null: false
      timestamps()
    end
    create index(:locations, [:ref_name, :world_type_ref], unique: true)

    create table(:location_events) do
      add :ref_name, :string, null: false
      add :location_ref, :string, null: false
      add :area_line_ref, :string, null: false
      timestamps()
    end
    create index(:location_events, [:ref_name, :location_ref], unique: true)
  end
end
