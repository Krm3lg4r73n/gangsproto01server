require Logger
alias GangsServer.Store

defmodule Mix.Tasks.GangsServer.ResetGameData do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Overwrites all game data in the database."
  def run(_) do
    Logger.configure(level: :info)
    ensure_started(Store.Repo, [])

    Path.wildcard(Path.expand("./game_data/**/*.json"))
    |> Stream.map(&to_schema_module/1)
    |> Enum.map(&clear_db/1)
    |> Enum.each(&read_file/1)

    IO.puts("")
  end

  defp to_schema_module(filename) do
    schema_module = "Elixir.GangsServer.Store.Schema." <>
                    Path.basename(filename, '.json')
    |> String.to_atom
    {filename, schema_module}
  end

  defp clear_db({filename, schema_module}) do
    Store.Repo.delete_all(schema_module)
    {filename, schema_module}
  end

  defp read_file({filename, schema_module}) do
    IO.write(Path.basename(filename, '.json'))

    File.read!(filename)
    |> Poison.decode!(keys: :atoms)
    |> Enum.each(&write_to_db(&1, schema_module))
  end

  defp write_to_db(params, schema_module) do
    struct(schema_module, params)
    |> Store.Repo.insert!
    IO.write(".")
  end
end
