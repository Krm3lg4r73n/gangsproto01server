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
    }
  end


  defp seed_locale do
    %Store.Schema.Locale{ref_name: "de", name: "Deutsch"}
    |> Store.Repo.insert!
  end

  defp seed_users do
    %{
      frank: %Store.Schema.User{name: "Frank", locale_ref: "de"},
    }
    |> Enum.reduce(%{}, fn ({key, value}, acc) ->
      Map.put(acc, key, Store.Repo.insert!(value))
    end)
  end

  defp seed_lines do
    %{
      "test_world.desc" => %Store.Schema.Line{locale_ref: "de", key: "test_world.desc", text: "Die Testwelt."},
    }
    |> Enum.map(fn {key, value} -> {key, Store.Repo.insert!(value)} end)
  end

  defp seed_world_type do
    %Store.Schema.WorldType{ref_name: "test_world", description_line: "test_world.desc"}
    |> Store.Repo.insert!
  end
end
