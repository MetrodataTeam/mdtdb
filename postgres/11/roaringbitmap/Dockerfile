FROM postgres:11
ARG ROARINGBITMAP_VERSION='0.5.0'
ADD https://github.com/ChenHuajun/pg_roaringbitmap/archive/v${ROARINGBITMAP_VERSION}.tar.gz /tmp/pg_roaringbitmap.tar.gz

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential postgresql-server-dev-11 \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -f UTF-8 -i zh_CN zh_CN.UTF-8 \
    && cd /tmp \
    && tar xzvf pg_roaringbitmap.tar.gz \
    && cd "pg_roaringbitmap-${ROARINGBITMAP_VERSION}" \
    && make \
    && make install \
    && rm -rf /tmp/*
