alias GangsServer.Store

defmodule DBHelper do
  def seed_and_sandbox do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Store.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Store.Repo, {:shared, self()})

    %{
      locale: seed_locale(),
      users: seed_users(),
      lines: seed_lines(),
      world_type: seed_world_type(),
      locations: seed_locations(),
    }
  end

  defp seed_locale do
    %Store.Schema.Locale{ref_name: "de", name: "Deutsch"}
    |> Store.Repo.insert!
  end

  defp seed_users do
    %{
      usr0: %Store.Schema.User{name: "User0", locale_ref: "de"},
    }
    |> insert_map()
  end

  defp seed_lines do
    %{
      de_wlt0_desc: %Store.Schema.Line{
        locale_ref: "de", key: "wlt0.desc", text: "Der erste Welttyp."},
      de_wlt0_loc0_name: %Store.Schema.Line{
        locale_ref: "de", key: "wlt0.loc0.name", text: "Die erste Location."},
      de_wlt0_loc1_name: %Store.Schema.Line{
        locale_ref: "de", key: "wlt0.loc1.name", text: "Die zweite Location."},
    }
    |> insert_map()
  end

  defp seed_world_type do
    %Store.Schema.WorldType{ref_name: "wlt0", description_line: "wlt0.desc"}
    |> Store.Repo.insert!
  end

  defp seed_locations do
    %{
      wlt0_loc0: %Store.Schema.Location{
        ref_name: "wlt0.loc0", world_type_ref: "wlt0", name_line: "wlt0.loc0.name"},
      wlt0_loc1: %Store.Schema.Location{
        ref_name: "wlt0.loc1", world_type_ref: "wlt0", name_line: "wlt0.loc1.name"},
    }
    |> insert_map()
  end

  defp insert_map(data) do
    Enum.reduce(data, %{}, fn ({key, value}, acc) ->
      Map.put(acc, key, Store.Repo.insert!(value))
    end)
  end
end
