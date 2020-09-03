FROM postgis/postgis:12-3.0
ARG OSSUTIL_VERSION='1.6.18'
ARG ROARINGBITMAP_VERSION='0.5.2'
# https://pgroonga.github.io/
ARG PGROONGA_VERSION='2.2.6-2'
ARG CITUS='9.4'
ARG PG_LOGICAL_VERSION='2.3.2-1.pgdg100+1'
ADD https://install.citusdata.com/community/deb.sh /tmp/deb.sh
ADD http://gosspublic.alicdn.com/ossutil/${OSSUTIL_VERSION}/ossutil64 /usr/bin/
ADD https://github.com/ChenHuajun/pg_roaringbitmap/archive/v${ROARINGBITMAP_VERSION}.tar.gz /tmp/pg_roaringbitmap.tar.gz
ADD https://packages.groonga.org/debian/groonga-archive-keyring-latest-buster.deb /tmp/groonga-archive-keyring-latest-buster.deb
ADD https://access.2ndquadrant.com/api/repository/dl/default/release/deb /tmp/pglogical.deb
ADD https://packagecloud.io/timescale/timescaledb/gpgkey /tmp/gpgkey
ENV OSSUTIL_CONFIG_FILE='/var/lib/postgresql/data/.ossutilconfig'
RUN echo 'deb http://packagecloud.io/timescale/timescaledb/debian/ buster main' > /etc/apt/sources.list.d/timescaledb.list && \
    apt-key add /tmp/gpgkey && \
    localedef -f UTF-8 -i zh_CN zh_CN.UTF-8 && \
    apt-get update && \
    apt-get install -y --no-install-recommends build-essential postgresql-server-dev-12 rsync ca-certificates && \
    # pglogical
    cat /tmp/pglogical.deb | bash && \
    apt-get install -y --no-install-recommends postgresql-12-pglogical=${PG_LOGICAL_VERSION} && \
    # timescaledb
    apt-get install -y --no-install-recommends timescaledb-postgresql-12 && \
    # citus
    chmod +x /tmp/deb.sh && \
    /tmp/deb.sh && \
    apt-get install -y --no-install-recommends postgresql-12-citus-${CITUS} && \
    # pgroonga
    apt-get install -y -V /tmp/groonga-archive-keyring-latest-buster.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends postgresql-12-pgdg-pgroonga=${PGROONGA_VERSION} && \
    # repmgr
    apt-get install -y --no-install-recommends postgresql-12-repmgr && \
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
