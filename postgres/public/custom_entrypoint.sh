#!/usr/bin/env bash
set -Eeo pipefail

source docker-entrypoint.sh
if [ "$#" -eq 0 ] || [ "$1" != 'postgres' ]; then
  set -- postgres "$@"
fi

docker_setup_env
docker_create_db_directories

if [ "$(id -u)" = '0' ]; then
  # then restart script as postgres user
  if type gosu > /dev/null 2>&1; then
    exec gosu postgres "$BASH_SOURCE" "$@"
  else
    exec su-exec postgres "$BASH_SOURCE" "$@"
  fi
fi

if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
  _main "$@" -c mdt.mdtdb_version=$PG_MAJOR.$MDTDB_VERSION
else
  exec "$@" -c mdt.mdtdb_version=$PG_MAJOR.$MDTDB_VERSION
fi
