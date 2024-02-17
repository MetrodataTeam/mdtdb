#!/bin/bash

set -e

# notice: this only works on db initialization, which won't effect if we change image later
function create_function_mdtdb_version() {
	local database=$1
	echo "  Creating Function mdtdb_version on database '$database'."
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname="$database" <<-EOSQL
	    CREATE FUNCTION PUBLIC.mdtdb_version() RETURNS TEXT AS \$\$ select '$MDTDB_VERSION' as mdtdb_version \$\$ LANGUAGE SQL IMMUTABLE;
EOSQL
}

all_db=$(psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname="$POSTGRES_DB" -c "select datname from pg_database where datallowconn = true" -t -A -q -R ",")
for db in $(echo $all_db | tr ',' ' '); do
  create_function_mdtdb_version $db
done
echo "The creation of function mdtdb_version on all databases has been completed."
