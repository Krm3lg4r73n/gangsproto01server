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
    |> Enum.each(&read_file/1)

    IO.puts("")
  end

  defp read_file(filename) do
    model_module = "Elixir.GangsServer.Store.Schemas." <>
                   Path.basename(filename, '.json')
    |> String.to_existing_atom

    Store.Repo.delete_all(model_module)
    IO.write(Path.basename(filename, '.json'))

    File.read!(filename)
    |> Poison.decode!(keys: :atoms)
    |> Enum.each(&write_to_db(&1, model_module))
  end

  defp write_to_db(params, model_module) do
    struct(model_module, params)
    |> Store.Repo.insert!
    IO.write(".")
  end

end
