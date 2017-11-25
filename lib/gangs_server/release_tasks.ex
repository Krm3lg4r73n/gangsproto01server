defmodule GangsServer.ReleaseTasks do

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :logger
  ]

  def migrate do
    IO.puts "Creating and migrating databases..."
    {:ok, repos} = load_app()
    
    # Creating databases
    Enum.each(repos, &create_database_for/1)

    # Start the Repo(s) for the app
    Enum.each(repos, &(&1.start_link(pool_size: 1)))
    
    # Run migrations
    Enum.each(repos, &run_migrations_for/1)

    IO.puts "Success!"
    :init.stop()
  end

  def seed do
    IO.puts "Seeding databases..."
    {:ok, _repos} = load_app()
    
    # Reset game data
    Mix.Tasks.GangsServer.ResetGameData.run(:_)

    IO.puts "Success!"
    :init.stop()
  end

  defp load_app() do
    :ok = Application.load(:gangs_server)
    Enum.each(@start_apps, &Application.ensure_all_started/1)
    {:ok, Application.get_env(:gangs_server, :ecto_repos, [])}
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp create_database_for(repo) do
    IO.puts "Creating database for #{inspect repo}"
    case repo.__adapter__.storage_up(repo.config) do
      :ok ->
        IO.puts "The database for #{inspect repo} has been created"
      {:error, :already_up} ->
        IO.puts "The database for #{inspect repo} has already been created"
      {:error, term} when is_binary(term) ->
        IO.puts "The database for #{inspect repo} couldn't be created: #{term}"
      {:error, term} ->
        IO.puts "The database for #{inspect repo} couldn't be created: #{inspect term}"
    end
  end

  defp run_migrations_for(repo) do
    IO.puts "Running migrations for #{inspect repo}"
    Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  defp migrations_path(repo), do: priv_path_for(repo, "migrations")

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split |> List.last |> Macro.underscore
    Path.join([priv_dir(app), repo_underscore, filename])
  end
end