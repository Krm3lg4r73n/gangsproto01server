use Mix.Config

config :gangs_server, GangsServer.Store.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("POSTGRES_URL") || "postgres://postgres:postgres@localhost:5432/gangs_server_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger,
  level: :error
