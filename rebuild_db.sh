#!/bin/sh

mix ecto.drop
mix ecto.create
mix ecto.migrate

MIX_ENV=test mix ecto.drop
MIX_ENV=test mix ecto.create
MIX_ENV=test mix ecto.migrate

mix gangs_server.reset_game_data
