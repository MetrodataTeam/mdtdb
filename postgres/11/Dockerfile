FROM postgis/postgis:11-2.5
ARG OSSUTIL_VERSION='1.6.18'
ARG ROARINGBITMAP_VERSION='0.5.2'
# https://pgroonga.github.io/
ARG PGROONGA_VERSION='2.2.6-2'
ARG PGROUNTING_VERSION='3.0.2-1.pgdg90+1'
ARG TIMESCALEDB_VERSION='1.7.3~debian9'
ARG REPMGR_VERSION='5.1.0-2.stretch+1'
ARG PG_LOGICAL_VERSION='2.3.2-1.stretch+1'
ADD http://gosspublic.alicdn.com/ossutil/${OSSUTIL_VERSION}/ossutil64 /usr/bin/
ADD https://github.com/ChenHuajun/pg_roaringbitmap/archive/v${ROARINGBITMAP_VERSION}.tar.gz /tmp/pg_roaringbitmap.tar.gz
ADD https://packages.groonga.org/debian/groonga-apt-source-latest-stretch.deb /tmp/groonga-archive-keyring-latest-stretch.deb
ADD https://access.2ndquadrant.com/api/repository/dl/default/release/deb /tmp/pglogical.deb
ADD https://packagecloud.io/timescale/timescaledb/gpgkey /tmp/gpgkey
ENV OSSUTIL_CONFIG_FILE='/var/lib/postgresql/data/.ossutilconfig'
ENV INSTALL='apt-get install -y --no-install-recommends'
RUN localedef -f UTF-8 -i zh_CN zh_CN.UTF-8 && \
    apt-get update && \
    ${INSTALL} build-essential postgresql-server-dev-11 rsync ca-certificates && \
    # pglogical
    cat /tmp/pglogical.deb | bash && \
    ${INSTALL} postgresql-11-pglogical=${PG_LOGICAL_VERSION} && \
    # pgrouting
    ${INSTALL} postgresql-11-pgrouting=${PGROUNTING_VERSION} && \
    # timescaledb
    echo 'deb http://packagecloud.io/timescale/timescaledb/debian/ stretch main' > /etc/apt/sources.list.d/timescaledb.list && \
    apt-key add /tmp/gpgkey && \
    apt-get update && \
    ${INSTALL} timescaledb-postgresql-11=${TIMESCALEDB_VERSION} && \
    # pgroonga
    apt-get install -y -V /tmp/groonga-archive-keyring-latest-stretch.deb && \
    apt-get update && \
    ${INSTALL} postgresql-11-pgroonga=${PGROONGA_VERSION} groonga-tokenizer-mecab && \
    # repmgr
    ${INSTALL} postgresql-11-repmgr=${REPMGR_VERSION} && \
    # ossutil
    chmod a+x /usr/bin/ossutil64 && \
    ln -s /usr/bin/ossutil64 /usr/bin/ossutil && \
    # roaring bitmap
    cd /tmp && \
    tar xzvf pg_roaringbitmap.tar.gz && \
    cd "pg_roaringbitmap-${ROARINGBITMAP_VERSION}" && \
    make && \
    make install && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/*
