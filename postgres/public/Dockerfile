ARG BASE_IMAGE

FROM ${BASE_IMAGE} as mdtdb

ARG DEBIAN_FRONTEND=noninteractive
ARG ARCH=amd64

# https://github.com/postgis/docker-postgis
ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION '3.5.2*'

ARG MDTDB_VERSION
ENV MDTDB_VERSION=${MDTDB_VERSION}

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./update-postgis.sh /usr/local/bin
COPY ./multiple_db.sh /docker-entrypoint-initdb.d/11_multiple_db.sh
COPY ./set_version.sh /docker-entrypoint-initdb.d/80_set_version.sh

COPY ./custom_entrypoint.sh /usr/local/bin/custom_entrypoint.sh

ENV OSSUTIL_CONFIG_FILE='/var/lib/postgresql/data/.ossutilconfig'
ENV INSTALL='apt-get install -y --no-install-recommends --no-upgrade'
ARG MIRROR

# https://github.com/aliyun/ossutil/releases
# https://help.aliyun.com/zh/oss/developer-reference/install-ossutil
ARG OSSUTIL_VERSION='1.7.19'
ADD https://${MIRROR}/raw-dev/backend/ossutil/${OSSUTIL_VERSION}/ossutil64.${ARCH} /usr/bin/

# https://github.com/ChenHuajun/pg_roaringbitmap/releases
ARG ROARINGBITMAP_VERSION='0.5.4*'

# https://github.com/EnterpriseDB/repmgr/releases
# https://apt.postgresql.org/pub/repos/apt/pool/main/r/repmgr/
# ARG REPMGR_VERSION='5.4.1*'

# https://github.com/eulerto/wal2json/releases
ARG WAL2JSON_VERSION='2.6*'

# https://github.com/pramsey/pgsql-http/releases
ARG PGSQL_HTTP_VERSION='1.6.3*'

# https://github.com/pgvector/pgvector/blob/master/CHANGELOG.md
ARG PGVECTOR_VERSION='0.8.0*'

# https://github.com/bytesandbrains/h3-pg/releases
ARG H3PG_VERSION='4.2.2*'

# https://github.com/ossc-db/pg_hint_plan/tags
# different by pg major
ARG PG_HINT_PLAN_VERSION=''

# https://github.com/2ndQuadrant/pglogical/releases
# https://apt.postgresql.org/pub/repos/apt/pool/main/p/pglogical/
ARG PGLOGICAL_VERSION='2.4.5*'
# https://github.com/enova/pgl_ddl_deploy/releases
ARG PGL_DDL_DEPLOY_VERSION='2.2.1*'

# https://github.com/tembo-io/pgmq/releases
ARG PGMQ_VERSION='1.5.1*'

# https://github.com/pgaudit/pgaudit/releases
# different by pg major
ARG PGAUDIT_VERSION=''

# https://github.com/citusdata/pg_cron/releases
ARG PG_CRON_VERSION='1.6.5*'

# https://github.com/pgRouting/pgrouting/releases
# NOTICE: repo keeps deleting old artifacts, we may change this
ARG PGROUTING_VERSION='3.7.3*'

# https://gitlab.com/dalibo/postgresql_anonymizer/-/tags
# https://ext.pigsty.io/#/anon
ARG ANONYMIZER_VERSION='2.1.1*'

# https://github.com/citusdata/postgresql-hll/releases
ARG POSTGRESQL_HLL_VERSION='2.18*'

# https://github.com/paradedb/paradedb/releases
ARG PG_SEARCH_VERSION='0.15.20*'

# https://github.com/tensorchord/VectorChord/releases
ARG VECTOR_CHORD_VERSION='0.3.0*'

# https://github.com/supabase/pg_jsonschema/releases
ARG PG_JSONSCHEMA_VERSION='0.3.3*'

# https://github.com/MobilityDB/MobilityDB/releases
ARG MOBILITYDB_VERSION='1.2.0*'

# https://ext.pigsty.io/#/pg_duckdb
ARG PG_DUCKDB='0.3.1*'

ADD https://repo.pigsty.io/key /tmp/pigsty.key

RUN export VERSION_CODENAME=`grep VERSION_CODENAME /etc/os-release | sed 's/VERSION_CODENAME=//'` && \
    echo "deb "http://${MIRROR}"/apt-debian/ "${VERSION_CODENAME}" main contrib" > /etc/apt/sources.list && \
    rm -f /etc/apt/sources.list.d/debian.sources && \
    echo "deb "http://${MIRROR}"/apt-postgresql/ "${VERSION_CODENAME}"-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8 && \
    cat /tmp/pigsty.key | gpg --dearmor -o /etc/apt/keyrings/pigsty.gpg && \
    echo "deb  [signed-by=/etc/apt/keyrings/pigsty.gpg] "http://${MIRROR}"/apt-pigsty/infra generic main" > /etc/apt/sources.list.d/pigsty.list && \
    echo "deb  [signed-by=/etc/apt/keyrings/pigsty.gpg] "http://${MIRROR}"/apt-pigsty/pgsql/bookworm bookworm main" >> /etc/apt/sources.list.d/pigsty.list && \
    # echo "deb [arch="${ARCH}" signed-by=/usr/share/keyrings/pgxman-cli.gpg] http://"${MIRROR}"/apt-pgxman/cli stable main" > /etc/apt/sources.list.d/pgxman.list && \
    apt-get update && \
    # NOTICE: handle version imcompaticility here
    # apt remove -y libssl3 && ${INSTALL} --allow-downgrades --reinstall libssl3=3.0.14-1~deb12u1 && \
    # crontab
    ${INSTALL} cron && \
    # pg_duckdb
    ${INSTALL} postgresql-${PG_MAJOR}-pg-duckdb=${PG_DUCKDB} \
    # h3pg
    postgresql-${PG_MAJOR}-h3=${H3PG_VERSION} \
    # pg_jsonschema
    postgresql-${PG_MAJOR}-pg-jsonschema=${PG_JSONSCHEMA_VERSION} \
    # vector chord (vchord)
    postgresql-${PG_MAJOR}-vchord=${VECTOR_CHORD_VERSION} \
    # paradedb pg_search
    postgresql-${PG_MAJOR}-pg-search=${PG_SEARCH_VERSION} \
    # pgmq
    postgresql-${PG_MAJOR}-pgmq=${PGMQ_VERSION} \
    # postgresql-hll
    postgresql-${PG_MAJOR}-hll=${POSTGRESQL_HLL_VERSION} \
    # postgresql_anonymizer
    postgresql-${PG_MAJOR}-pg-anon=${ANONYMIZER_VERSION} \
    # pgrouting
    postgresql-${PG_MAJOR}-pgrouting=${PGROUTING_VERSION} \
    # pg_cron
    postgresql-${PG_MAJOR}-cron=${PG_CRON_VERSION} \
    # pgaudit
    postgresql-${PG_MAJOR}-pgaudit=${PGAUDIT_VERSION} \
    # postgis
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}=${POSTGIS_VERSION} \
    postgresql-${PG_MAJOR}-postgis-${POSTGIS_MAJOR}-scripts \
    # modilitydb, must install after postgis
    postgresql-${PG_MAJOR}-mobilitydb=${MOBILITYDB_VERSION} \
    # pglogical
    postgresql-${PG_MAJOR}-pglogical=${PGLOGICAL_VERSION} \
    # pgl-ddl-deploy
    postgresql-${PG_MAJOR}-pgl-ddl-deploy=${PGL_DDL_DEPLOY_VERSION} \
    # pg_hint_plan
    postgresql-${PG_MAJOR}-pg-hint-plan=${PG_HINT_PLAN_VERSION} \
    # pgvector
    postgresql-${PG_MAJOR}-pgvector=${PGVECTOR_VERSION} \
    # wal2json
    postgresql-${PG_MAJOR}-wal2json=${WAL2JSON_VERSION} \
    # roaring bitmap
    postgresql-${PG_MAJOR}-roaringbitmap=${ROARINGBITMAP_VERSION} \
    # pgsql-http
    postgresql-${PG_MAJOR}-http=${PGSQL_HTTP_VERSION} && \
    # ossutil
    chmod a+x /usr/bin/ossutil64.${ARCH} && \
    ln -s /usr/bin/ossutil64.${ARCH} /usr/bin/ossutil && \
    # increase max open files soft limit for postgres
    echo "postgres soft nofile 100000" >> /etc/security/limits.conf && \
    # clean up
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["custom_entrypoint.sh"]
