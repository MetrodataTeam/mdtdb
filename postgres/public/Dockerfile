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
ARG ROARINGBITMAP_VERSION='0.5.4'

# https://github.com/EnterpriseDB/repmgr/releases
# https://apt.postgresql.org/pub/repos/apt/pool/main/r/repmgr/
# ARG REPMGR_VERSION='5.4.1*'

# https://github.com/eulerto/wal2json/releases
ARG WAL2JSON_VERSION='2.6*'

# https://github.com/pramsey/pgsql-http/releases
ARG PGSQL_HTTP_VERSION='1.6.1'

# https://github.com/pgvector/pgvector/blob/master/CHANGELOG.md
ARG PGVECTOR_VERSION='0.8.0'

# https://github.com/bytesandbrains/h3-pg/releases
ARG H3PG_VERSION='4.2.2*'

# https://github.com/ossc-db/pg_hint_plan/tags
# update ci build args as it differes each pg major
ARG PG_HINT_PLAN_VERSION=''

# https://github.com/2ndQuadrant/pglogical/releases
# https://apt.postgresql.org/pub/repos/apt/pool/main/p/pglogical/
ARG PGLOGICAL_VERSION='2.4.5*'
# https://github.com/enova/pgl_ddl_deploy/releases
ARG PGL_DDL_DEPLOY_VERSION='2.2.1*'

# https://github.com/tembo-io/pgmq/releases
ARG PGMQ_VERSION='1.4.5'

# https://github.com/apache/age/releases
ARG AGE_VERSION='1.5.0'

# https://github.com/pgaudit/pgaudit/releases
ARG PGAUDIT_VERSION=''

# https://github.com/citusdata/pg_cron/releases
ARG PG_CRON_VERSION='1.6.5*'

# https://github.com/pgRouting/pgrouting/releases
# NOTICE: repo keeps deleting old artifacts, we may change this
ARG PGROUTING_VERSION='3.7.3*'

# https://gitlab.com/dalibo/postgresql_anonymizer/-/tags
ARG ANONYMIZER_VERSION='1.3.2'

# https://github.com/citusdata/postgresql-hll/releases
ARG POSTGRESQL_HLL_VERSION='2.18'

# https://github.com/paradedb/paradedb/releases
ARG PARADEDB_VERSION='0.15.4'
# https://github.com/paradedb/pg_analytics/releases
ARG PG_ANALYTICS_VERSION='0.3.5'

# https://github.com/tensorchord/pgvecto.rs/releases
ARG PG_VECTORS_VERSION='0.4.0'

# https://github.com/supabase/pg_jsonschema/releases
ARG PG_JSONSCHEMA_VERSION='0.3.3'

# https://github.com/MobilityDB/MobilityDB/releases
ARG MOBILITYDB_VERSION='1.1.2'

# https://ext.pigsty.io/#/pg_duckdb
ARG PG_DUCKDB='0.3.1*'

ADD https://repo.pigsty.io/key /tmp/pigsty.key

# ADD https://"${MIRROR}"/apt-pgxman/pgxman-keyring.gpg /usr/share/keyrings/pgxman-cli.gpg
RUN export VERSION_CODENAME=`grep VERSION_CODENAME /etc/os-release | sed 's/VERSION_CODENAME=//'` && \
    export WGET='wget -nv --directory-prefix=/tmp/ ' && \
    echo "deb "http://${MIRROR}"/apt-debian/ "${VERSION_CODENAME}" main contrib" > /etc/apt/sources.list && \
    rm -f /etc/apt/sources.list.d/debian.sources && \
    echo "deb "http://${MIRROR}"/apt-postgresql/ "${VERSION_CODENAME}"-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8 && \
    echo "deb "http://${MIRROR}"/arrow/ "${VERSION_CODENAME}" main" > /etc/apt/sources.list.d/arrow.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 91D18FCF079F8007 && \
    cat /tmp/pigsty.key | gpg --dearmor -o /etc/apt/keyrings/pigsty.gpg && \
    echo "deb  [signed-by=/etc/apt/keyrings/pigsty.gpg] "http://${MIRROR}"/apt-pigsty/infra generic main" > /etc/apt/sources.list.d/pigsty.list && \
    echo "deb  [signed-by=/etc/apt/keyrings/pigsty.gpg] "http://${MIRROR}"/apt-pigsty/pgsql/bookworm bookworm main" >> /etc/apt/sources.list.d/pigsty.list && \
    # echo "deb [arch="${ARCH}" signed-by=/usr/share/keyrings/pgxman-cli.gpg] http://"${MIRROR}"/apt-pgxman/cli stable main" > /etc/apt/sources.list.d/pgxman.list && \
    apt-get update && \
    # NOTICE: handle version imcompaticility here
    # apt remove -y libssl3 && ${INSTALL} --allow-downgrades --reinstall libssl3=3.0.14-1~deb12u1 && \
    ${INSTALL} postgresql-server-dev-${PG_MAJOR} build-essential ca-certificates wget cmake \
    # crontab
    cron \
    # age
    bison flex \
    # pgaudit
    libkrb5-dev \
    # https://github.com/MobilityDB/MobilityDB/blob/master/docker/Dockerfile#L22
    #  mobilitydb
    libproj-dev \
    libjson-c-dev \
    libgsl-dev \
    libgeos-dev \
    # pgsql-http
    libcurl4 libcurl4-openssl-dev && \
    # pg_duckdb
    ${INSTALL} postgresql-${PG_MAJOR}-pg-duckdb=${PG_DUCKDB} && \
    # h3pg
    ${INSTALL} postgresql-${PG_MAJOR}-h3=${H3PG_VERSION} && \
    # pg_jsonschema
    ${WGET}https://${MIRROR}/github/supabase/pg_jsonschema/releases/download/v${PG_JSONSCHEMA_VERSION}/pg_jsonschema-v${PG_JSONSCHEMA_VERSION}-pg${PG_MAJOR}-${ARCH}-linux-gnu.deb && \
    cd /tmp/ && \
    apt install /tmp/pg_jsonschema-v${PG_JSONSCHEMA_VERSION}-pg${PG_MAJOR}-${ARCH}-linux-gnu.deb && \
    # pg vecto.rs
    ${WGET}https://${MIRROR}/github/tensorchord/pgvecto.rs/releases/download/v${PG_VECTORS_VERSION}/vectors-pg${PG_MAJOR}_${PG_VECTORS_VERSION}_${ARCH}.deb && \
    cd /tmp/ && \
    apt install /tmp/vectors-pg${PG_MAJOR}_${PG_VECTORS_VERSION}_${ARCH}.deb && \
    # paradedb pg_search
    ${WGET}https://${MIRROR}/github/paradedb/paradedb/releases/download/v${PARADEDB_VERSION}/postgresql-${PG_MAJOR}-pg-search_${PARADEDB_VERSION}-1PARADEDB-bookworm_${ARCH}.deb && \
    apt install /tmp/postgresql-${PG_MAJOR}-pg-search_${PARADEDB_VERSION}-1PARADEDB-bookworm_${ARCH}.deb && \
    # paradedb pg_analytics
    ${WGET}https://${MIRROR}/github/paradedb/pg_analytics/releases/download/v${PG_ANALYTICS_VERSION}/postgresql-${PG_MAJOR}-pg-analytics_${PG_ANALYTICS_VERSION}-1PARADEDB-bookworm_${ARCH}.deb && \
    apt install /tmp/postgresql-${PG_MAJOR}-pg-analytics_${PG_ANALYTICS_VERSION}-1PARADEDB-bookworm_${ARCH}.deb && \
    # pgmq
    ${WGET}https://${MIRROR}/github/tembo-io/pgmq/archive/refs/tags/v${PGMQ_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf v${PGMQ_VERSION}.tar.gz && \
    cd pgmq-${PGMQ_VERSION}/pgmq-extension && \
    make && \
    make install && \
    # postgresql-hll
    ${WGET}https://${MIRROR}/github/citusdata/postgresql-hll/archive/refs/tags/v${POSTGRESQL_HLL_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf v${POSTGRESQL_HLL_VERSION}.tar.gz && \
    cd postgresql-hll-${POSTGRESQL_HLL_VERSION} && \
    make && \
    make install && \
    # postgresql_anonymizer
    ${WGET}https://${MIRROR}/gitlab/dalibo/postgresql_anonymizer/-/archive/${ANONYMIZER_VERSION}/postgresql_anonymizer-${ANONYMIZER_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf postgresql_anonymizer-${ANONYMIZER_VERSION}.tar.gz && \
    cd postgresql_anonymizer-${ANONYMIZER_VERSION} && \
    make extension && \
    make install && \
    # pgrouting
    ${INSTALL} postgresql-${PG_MAJOR}-pgrouting=${PGROUTING_VERSION} && \
    # pg_cron
    ${INSTALL} postgresql-${PG_MAJOR}-cron=${PG_CRON_VERSION} && \
    # pgaudit
    ${WGET}https://${MIRROR}/github/pgaudit/pgaudit/archive/refs/tags/${PGAUDIT_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf ${PGAUDIT_VERSION}.tar.gz && \
    cd pgaudit-${PGAUDIT_VERSION} && \
    make USE_PGXS=1 && \
    make install USE_PGXS=1 && \
    # age
    if [ ${PG_MAJOR} -ge 17 ]; then \
      ${WGET}https://${MIRROR}/github/MetrodataTeam/age/archive/refs/tags/v1.5.0.1.tar.gz && \
      cd /tmp/ && \
      tar xzvf v1.5.0.1.tar.gz && \
      cd age-1.5.0.1 && \
      make install ; \
    fi && \
    if [ ${PG_MAJOR} -lt 17 ]; then \
      ${WGET}https://${MIRROR}/github/apache/age/releases/download/PG${PG_MAJOR}/v${AGE_VERSION}-rc0/apache-age-${AGE_VERSION}-src.tar.gz && \
      cd /tmp/ && \
      tar xzvf apache-age-${AGE_VERSION}-src.tar.gz && \
      cd apache-age-${AGE_VERSION} && \
      make install ; \
    fi && \
    # postgis
    ${INSTALL} \
        postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
        postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts && \
    # modilitydb, must install after postgis
    ${WGET}https://${MIRROR}/github/MobilityDB/MobilityDB/archive/v${MOBILITYDB_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf v${MOBILITYDB_VERSION}.tar.gz && \
    cd MobilityDB-${MOBILITYDB_VERSION} && \
    mkdir build && \
    cd build && \
    cmake ..  && \
    make -j4 && \
    make install && \
    # pglogical
    ${INSTALL} postgresql-${PG_MAJOR}-pglogical=${PGLOGICAL_VERSION} && \
    # pgl-ddl-deploy
    ${INSTALL} postgresql-${PG_MAJOR}-pgl-ddl-deploy=${PGL_DDL_DEPLOY_VERSION} && \
    # pg_hint_plan
    ${WGET}https://${MIRROR}/github/ossc-db/pg_hint_plan/archive/refs/tags/${PG_HINT_PLAN_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf ${PG_HINT_PLAN_VERSION}.tar.gz && \
    cd pg_hint_plan-${PG_HINT_PLAN_VERSION} && \
    make && \
    make install && \
    # pgvector
    ${WGET}https://${MIRROR}/github/pgvector/pgvector/archive/refs/tags/v${PGVECTOR_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf v${PGVECTOR_VERSION}.tar.gz && \
    cd pgvector-${PGVECTOR_VERSION} && \
    # https://github.com/pgvector/pgvector/issues/143
    make OPTFLAGS="" && \
    make install && \
    # repmgr
    # ${INSTALL} postgresql-${PG_MAJOR}-repmgr=${REPMGR_VERSION} && \
    # wal2json
    ${INSTALL} postgresql-${PG_MAJOR}-wal2json=${WAL2JSON_VERSION} && \
    # ossutil
    chmod a+x /usr/bin/ossutil64.${ARCH} && \
    ln -s /usr/bin/ossutil64.${ARCH} /usr/bin/ossutil && \
    # roaring bitmap
    ${WGET}https://${MIRROR}/github/ChenHuajun/pg_roaringbitmap/archive/refs/tags/v${ROARINGBITMAP_VERSION}.tar.gz && \
    cd /tmp && \
    tar xzvf v${ROARINGBITMAP_VERSION}.tar.gz && \
    cd pg_roaringbitmap-${ROARINGBITMAP_VERSION} && \
    make && \
    make install && \
    # pgsql-http
    ${WGET}https://${MIRROR}/github/pramsey/pgsql-http/archive/refs/tags/v${PGSQL_HTTP_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf v${PGSQL_HTTP_VERSION}.tar.gz && \
    cd pgsql-http-${PGSQL_HTTP_VERSION} && \
    make && \
    make install && \
    # increase max open files soft limit for postgres
    echo "postgres soft nofile 100000" >> /etc/security/limits.conf && \
    # clean up
    rm -rf /tmp/* && \
    apt-get autoremove -y --purge libcurl4-openssl-dev postgresql-server-dev-${PG_MAJOR} build-essential wget libkrb5-dev cmake && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["custom_entrypoint.sh"]
