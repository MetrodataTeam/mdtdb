ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ARG DEBIAN_FRONTEND=noninteractive
ARG IS_ARM=false

# https://github.com/postgis/docker-postgis
ENV POSTGIS_MAJOR 3
ENV POSTGIS_VERSION '3.4.2*'

ARG MDTDB_VERSION
ENV MDTDB_VERSION=${MDTDB_VERSION}

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./update-postgis.sh /usr/local/bin
COPY ./multiple_db.sh /docker-entrypoint-initdb.d/11_multiple_db.sh
COPY ./set_version.sh /docker-entrypoint-initdb.d/80_set_version.sh

ENV OSSUTIL_CONFIG_FILE='/var/lib/postgresql/data/.ossutilconfig'
ENV INSTALL='apt-get install -y --no-install-recommends --no-upgrade'
ARG NEXUS

# https://github.com/timescale/timescaledb/releases
# ADD https://packagecloud.io/timescale/timescaledb/gpgkey /tmp/timescaledb_gpgkey
# ARG TIMESCALEDB_VERSION='2.9.2*'

# https://github.com/aliyun/ossutil/releases
# wget https://gosspublic.alicdn.com/ossutil/${OSSUTIL_VERSION}/ossutil64
ARG OSSUTIL_VERSION='1.7.14'
ADD ${NEXUS}/repository/raw-dev/backend/ossutil/${OSSUTIL_VERSION}/ossutil64 /usr/bin/

# https://github.com/ChenHuajun/pg_roaringbitmap/releases
ARG ROARINGBITMAP_VERSION='0.5.4'

# https://github.com/EnterpriseDB/repmgr/releases
# https://apt.postgresql.org/pub/repos/apt/pool/main/r/repmgr/
ARG REPMGR_VERSION='5.4.1*'

# https://github.com/eulerto/wal2json/releases
ARG WAL2JSON_VERSION='2.5*'

# TODO(Deo): re-enable this once it's more easy to build
# https://github.com/pgspider/parquet_s3_fdw/releases
# ARG PARQUET_FDW_VERSION='1.1.0'

# https://github.com/EnterpriseDB/mysql_fdw/releases
ARG MYSQL_FDW_VERSION='2.9.1*'

# https://github.com/pramsey/pgsql-http/releases
ARG PGSQL_HTTP_VERSION='1.6.0'

# https://github.com/timescale/promscale_extension/releases
# ARG PROMSCALE_VERSION='0.7.0'

# https://github.com/citusdata/citus#install-citus-locally
# https://github.com/citusdata/citus/blob/main/CHANGELOG.md
# TODO(Deo): disable citus as we may not be using it shortly, for experimentation, use older versions
# ARG CITUS_VERSION='11.1'
# ADD https://repos.citusdata.com/community/gpgkey /tmp/citus.gpg

# https://github.com/pgvector/pgvector/blob/master/CHANGELOG.md
ARG PGVECTOR_VERSION='0.6.0'

# https://github.com/bytesandbrains/h3-pg/releases
ARG H3PG_VERSION='4.1.3*'

# https://github.com/ossc-db/pg_hint_plan/tags
# update ci build args as it differes each pg major
ARG PG_HINT_PLAN_VERSION=''

# https://github.com/2ndQuadrant/pglogical/releases
# https://apt.postgresql.org/pub/repos/apt/pool/main/p/pglogical/
ARG PGLOGICAL_VERSION='2.4.4*'
# https://github.com/enova/pgl_ddl_deploy/releases
ARG PGL_DDL_DEPLOY_VERSION='2.2.1*'

# TODO(Deo): add pgmq or pg_later

# https://github.com/apache/age/releases
ARG AGE_VERSION='1.5.0'

# https://github.com/pgaudit/pgaudit/releases
ARG PGAUDIT_VERSION=''

# https://github.com/citusdata/pg_cron/releases
ARG PG_CRON_VERSION='1.6.2*'

# https://github.com/pgRouting/pgrouting/releases
# NOTICE: repo keeps deleting old artifacts, we may change this
ARG PGROUTING_VERSION='3.6.1*'

# https://gitlab.com/dalibo/postgresql_anonymizer/-/tags
ARG ANONYMIZER_VERSION='1.2.0'

# https://github.com/citusdata/postgresql-hll/releases
ARG POSTGRESQL_HLL_VERSION='2.18'

# https://github.com/paradedb/paradedb/releases
# pg_sparse/pg_bm25/pg_analytics share the version number
ARG PARADEDB_VERSION='0.5.6'

# https://github.com/tensorchord/pgvecto.rs/releases
ARG PG_VECTORS_VERSION='0.2.0'

# https://github.com/supabase/pg_jsonschema/releases
ARG PG_JSONSCHEMA_VERSION='0.2.0'

RUN export VERSION_CODENAME=`grep VERSION_CODENAME /etc/os-release | sed 's/VERSION_CODENAME=//'` && \
    export WGET='wget -nv --directory-prefix=/tmp/ '${NEXUS}'/repository/raw-dev' && \
    echo "deb "${NEXUS}"/repository/apt-debian/ "${VERSION_CODENAME}" main contrib" > /etc/apt/sources.list && \
    echo "deb "${NEXUS}"/repository/apt-postgresql/ "${VERSION_CODENAME}"-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7FCC7D46ACCC4CF8 && \
    echo "deb "${NEXUS}"/repository/arrow/ "${VERSION_CODENAME}" main" > /etc/apt/sources.list.d/arrow.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 91D18FCF079F8007 && \
    # echo "deb "${NEXUS}"/repository/apt-timescaledb/ "${VERSION_CODENAME}" main" > /etc/apt/sources.list.d/timescaledb.list && \
    # cat /tmp/timescaledb_gpgkey | apt-key add - && \
    apt-get update && \
    # NOTICE: handle version imcompaticility here
    # ${INSTALL} --allow-downgrades libc6=2.31-13+deb11u6 && \
    ${INSTALL} postgresql-server-dev-${PG_MAJOR} build-essential ca-certificates wget cmake \
    # age
    bison flex \
    # pgaudit
    libkrb5-dev \
    # pgsql-http
    libcurl4 libcurl4-openssl-dev && \
    # h3pg
    ${INSTALL} postgresql-${PG_MAJOR}-h3=${H3PG_VERSION} && \
    export archi=arm64 && \
    if [ "${IS_ARM}" = "false" ]; then \
        export archi=amd64 ; \
    fi && \
    # pg_jsonschema, supports 14+
    if [ "${PG_MAJOR}" != "13" ]; then \
        ${WGET}/backend/pg_jsonschema/pg_jsonschema-v${PG_JSONSCHEMA_VERSION}-pg${PG_MAJOR}-${archi}-linux-gnu.deb && \
        cd /tmp/ && \
        apt install /tmp/pg_jsonschema-v${PG_JSONSCHEMA_VERSION}-pg${PG_MAJOR}-${archi}-linux-gnu.deb ; \
    fi && \
    # pg vecto.rs, supports 14+
    if [ "${PG_MAJOR}" != "13" ]; then \
        ${WGET}/backend/vectors/vectors-pg${PG_MAJOR}_${PG_VECTORS_VERSION}_${archi}.deb && \
        cd /tmp/ && \
        apt install /tmp/vectors-pg${PG_MAJOR}_${PG_VECTORS_VERSION}_${archi}.deb ; \
    fi && \
    # paradedb only supports pg15/16 at the moment
    if [ ${PG_MAJOR} -ge 15 ]; then \
        # install libicu manually to ubuntu latest version, since paradedb pre-build on ubuntu
        ${WGET}/backend/libicu/libicu70_70.1-2_${archi}.deb && \
        apt install /tmp/libicu70_70.1-2_${archi}.deb && \
        for ext in 'pg_bm25' 'pg_sparse' 'pg_analytics'; \
        do \
            echo "installing "${archi}" "${ext} && \
            ${WGET}/backend/paradedb/${ext}-v${PARADEDB_VERSION}-pg${PG_MAJOR}-${archi}-ubuntu2204.deb && \
            apt install /tmp/${ext}-v${PARADEDB_VERSION}-pg${PG_MAJOR}-${archi}-ubuntu2204.deb ; \
        done ; \
    fi && \
    # postgresql-hll
    ${WGET}/backend/postgresql-hll/postgresql-hll-${POSTGRESQL_HLL_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf postgresql-hll-${POSTGRESQL_HLL_VERSION}.tar.gz && \
    cd postgresql-hll-${POSTGRESQL_HLL_VERSION} && \
    make && \
    make install && \
    # postgresql_anonymizer
    ${WGET}/backend/postgresql_anonymizer/postgresql_anonymizer-${ANONYMIZER_VERSION}.tar.gz && \
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
    ${WGET}/backend/pgaudit/pgaudit-${PGAUDIT_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf pgaudit-${PGAUDIT_VERSION}.tar.gz && \
    cd pgaudit-${PGAUDIT_VERSION} && \
    make USE_PGXS=1 && \
    make install USE_PGXS=1 && \
    # age
    ${WGET}/backend/age/apache-age-pg${PG_MAJOR}-${AGE_VERSION}-src.tar.gz && \
    cd /tmp/ && \
    tar xzvf apache-age-pg${PG_MAJOR}-${AGE_VERSION}-src.tar.gz && \
    cd apache-age-${AGE_VERSION} && \
    make install && \
    # postgis
    ${INSTALL} \
        postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
        postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts && \
    # pglogical
    ${INSTALL} postgresql-${PG_MAJOR}-pglogical=${PGLOGICAL_VERSION} && \
    # pgl-ddl-deploy
    ${INSTALL} postgresql-${PG_MAJOR}-pgl-ddl-deploy=${PGL_DDL_DEPLOY_VERSION} && \
    # pg_hint_plan
    ${WGET}/backend/pg_hint_plan/pg_hint_plan-${PG_HINT_PLAN_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf pg_hint_plan-${PG_HINT_PLAN_VERSION}.tar.gz && \
    cd pg_hint_plan-${PG_HINT_PLAN_VERSION} && \
    make && \
    make install && \
    # pgvector
    ${WGET}/backend/pgvector/pgvector-${PGVECTOR_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf pgvector-${PGVECTOR_VERSION}.tar.gz && \
    cd pgvector-${PGVECTOR_VERSION} && \
    # https://github.com/pgvector/pgvector/issues/143
    make OPTFLAGS="" && \
    make install && \
    # timescaledb
    # ${INSTALL} timescaledb-2-postgresql-${PG_MAJOR}=${TIMESCALEDB_VERSION} timescaledb-2-loader-postgresql-${PG_MAJOR}=${TIMESCALEDB_VERSION} && \
    # repmgr
    ${INSTALL} postgresql-${PG_MAJOR}-repmgr=${REPMGR_VERSION} && \
    # wal2json
    ${INSTALL} postgresql-${PG_MAJOR}-wal2json=${WAL2JSON_VERSION} && \
    # ossutil
    chmod a+x /usr/bin/ossutil64 && \
    ln -s /usr/bin/ossutil64 /usr/bin/ossutil && \
    # roaring bitmap
    ${WGET}/backend/pg_roaringbitmap/pg_roaringbitmap-${ROARINGBITMAP_VERSION}.tar.gz && \
    cd /tmp && \
    tar xzvf pg_roaringbitmap-${ROARINGBITMAP_VERSION}.tar.gz && \
    cd pg_roaringbitmap-${ROARINGBITMAP_VERSION} && \
    make && \
    make install && \
    # mysql fdw
    ${INSTALL} postgresql-${PG_MAJOR}-mysql-fdw=${MYSQL_FDW_VERSION} && \
    # pgsql-http
    ${WGET}/backend/pgsql-http/pgsql-http-${PGSQL_HTTP_VERSION}.tar.gz && \
    cd /tmp/ && \
    tar xzvf pgsql-http-${PGSQL_HTTP_VERSION}.tar.gz && \
    cd "pgsql-http-${PGSQL_HTTP_VERSION}" && \
    make && \
    make install && \
    # increase max open files soft limit for postgres
    echo "postgres soft nofile 100000" >> /etc/security/limits.conf && \
    # clean up
    rm -rf /tmp/* && \
    apt-get autoremove -y --purge libcurl4-openssl-dev postgresql-server-dev-${PG_MAJOR} build-essential wget libkrb5-dev cmake && \
    rm -rf /var/lib/apt/lists/*
