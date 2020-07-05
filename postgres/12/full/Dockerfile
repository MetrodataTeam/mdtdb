FROM postgis/postgis:12-3.0
ARG OSSUTIL_VERSION='1.6.10'
ARG ROARINGBITMAP_VERSION='0.5.1'
ARG PGROONGA_VERSION='2.2.6'
ADD http://gosspublic.alicdn.com/ossutil/${OSSUTIL_VERSION}/ossutil64 /usr/bin/
ADD https://github.com/ChenHuajun/pg_roaringbitmap/archive/v${ROARINGBITMAP_VERSION}.tar.gz /tmp/pg_roaringbitmap.tar.gz
ADD https://packages.groonga.org/source/pgroonga/pgroonga-${PGROONGA_VERSION}.tar.gz /tmp/pgroonga.tar.gz
ENV OSSUTIL_CONFIG_FILE='/var/lib/postgresql/data/.ossutilconfig'
RUN localedef -f UTF-8 -i zh_CN zh_CN.UTF-8 && \
    apt-get update && \
    apt-get install -y --no-install-recommends build-essential libmsgpack-dev libgroonga-dev pkg-config postgresql-server-dev-12 rsync && \
    # https://pgroonga.github.io/install/source.html
    cd /tmp && \
    tar xzvf pgroonga.tar.gz && \
    cd "pgroonga-${PGROONGA_VERSION}" && \
    make HAVE_MSGPACK=1 && \
    make install && \
    # repmgr
    apt-get install -y --no-install-recommends postgresql-12-repmgr && \
    # pg_cron
    apt-get install -y --no-install-recommends postgresql-12-cron && \
    # ossutil
    chmod a+x /usr/bin/ossutil64 && \
    ln -s /usr/bin/ossutil64 /usr/bin/ossutil && \
    # roaring bitmap
    /tmp && \
    tar xzvf pg_roaringbitmap.tar.gz && \
    cd "pg_roaringbitmap-${ROARINGBITMAP_VERSION}" && \
    make && \
    make install && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/*
