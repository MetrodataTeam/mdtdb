FROM postgis/postgis:12-3.0
ARG OSSUTIL_VERSION='1.6.10'
ARG ROARINGBITMAP_VERSION='0.5.1'
ARG PGROONGA_VERSION='2.2.6-1'
ADD http://gosspublic.alicdn.com/ossutil/${OSSUTIL_VERSION}/ossutil64 /usr/bin/
ADD https://github.com/ChenHuajun/pg_roaringbitmap/archive/v${ROARINGBITMAP_VERSION}.tar.gz /tmp/pg_roaringbitmap.tar.gz
ADD https://packages.groonga.org/debian/groonga-archive-keyring-latest-buster.deb /tmp/groonga-archive-keyring-latest-buster.deb
ENV OSSUTIL_CONFIG_FILE='/var/lib/postgresql/data/.ossutilconfig'
RUN localedef -f UTF-8 -i zh_CN zh_CN.UTF-8 && \
    apt-get update && \
    apt-get install -y --no-install-recommends build-essential postgresql-server-dev-12 rsync ca-certificates && \
    # pgroonga
    apt-get install -y -V /tmp/groonga-archive-keyring-latest-buster.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends postgresql-12-pgroonga=${PGROONGA_VERSION} && \
    # repmgr
    apt-get install -y --no-install-recommends postgresql-12-repmgr && \
    # pg_cron
    apt-get install -y --no-install-recommends postgresql-12-cron && \
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
