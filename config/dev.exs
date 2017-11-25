use Mix.Config

config :gangs_server, GangsServer.Store.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL") || "postgres://postgres:postgres@localhost:5432/gangs_server"
