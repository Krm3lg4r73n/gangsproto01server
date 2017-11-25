use Mix.Config

config :gangs_server, GangsServer.Store.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "${DATABASE_URL}",
  ssl: true,
  pool_size: 1
