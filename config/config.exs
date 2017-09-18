use Mix.Config

import_config "#{Mix.env}.exs"

config :gangs_server,
  ecto_repos: [GangsServer.Store.Repo],
  network_event_handler: GangsServer.Messaging.NetworkEventHandler
