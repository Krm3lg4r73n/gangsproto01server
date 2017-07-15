require Logger
alias GangsServer.Store

defmodule Mix.Tasks.GangsServer.ClearTable do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Query

  @shortdoc "Clears a table in the database."
  def run([table_name|_]) do
    Logger.configure(level: :info)
    ensure_started(Store.Repo, [])

    count = (from t in table_name, select: count(t.id))
    |> Store.Repo.one

    "Table '#{table_name}' contains #{count} rows. Clear?"
    |> Mix.shell.yes?
    |> clear_table(table_name)
  end

  defp clear_table(false, _), do: Mix.shell.info "Aborted."
  defp clear_table(true, table_name) do
    {count, _} = (from t in table_name)
    |> Store.Repo.delete_all
    Mix.shell.info "#{count} rows deleted."
  end
end
