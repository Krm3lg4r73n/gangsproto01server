defmodule GangsServer.Mixfile do
  use Mix.Project

  def project do
    [app: :gangs_server,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger, :ecto, :postgrex, :cowboy, :plug],
     mod: {GangsServer.Application, []}]
  end

  defp deps do
    [
      {:exprotobuf, ">= 1.2.7"},
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13.3"},
      {:poison, "~> 3.1"},
      {:socket, "~> 0.3.12"},
      {:distillery, "~> 1.0.0"},
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"}
    ]
  end
end
