#!/bin/sh

DATABASE_TCP=$(echo $DATABASE_URL | sed -E "s/postgres:\/\/.+@/tcp:\/\//")
echo $DATABASE_TCP
dockerize -wait $DATABASE_TCP -timeout 20s

if [ "$1" = "test" ]; then
  echo "No tests configured"
else
  export REPLACE_OS_VARS=true
  ./bin/gangs_server migrate
  ./bin/gangs_server foreground
fi
