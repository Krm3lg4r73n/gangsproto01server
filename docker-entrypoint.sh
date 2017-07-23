#!/bin/sh

DATABASE_TCP=$(echo $POSTGRES_URL | sed -E "s/postgres:\/\/.+@/tcp:\/\//")
dockerize -wait $DATABASE_TCP -timeout 20s

if [ "$1" = "test" ]; then
  export MIX_ENV=test
  mix ecto.create
  mix ecto.migrate
  mix test
else
  export MIX_ENV=prod
  mix ecto.create
  mix ecto.migrate
  mix gangs_server.reset_game_data
  elixir --sname gangsserver -S mix run --no-halt
fi
