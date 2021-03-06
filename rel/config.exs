use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"Ra5%v6[uya]F`nJi*N=js<9~?oY:le?Xf@nHIzX}.@U=$hYw_b~7t)Jjc~*NBS/5"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"YyFKP{uElAAC~S4`o1)C2;9RmON{LMAd73vBagvy[mZ3?U:5g:cc8he>IYLJ|HKN"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :gangs_server do
  set version: current_version(:gangs_server)
  set commands: [
    "migrate": "rel/commands/migrate.sh",
    "seed": "rel/commands/seed.sh"
  ]
end

