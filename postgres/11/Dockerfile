# build with all exetenstions preinstalled
FROM mdillon/postgis:11
RUN localedef -f UTF-8 -i zh_CN zh_CN.UTF-8

# https://.github.io/install/debian.html
ADD pgroonga/groonga-archive-keyring.gpg /usr/share/keyrings/groonga-archive-keyring.gpg

RUN apt-get update \
    && apt-get install -y -V apt-transport-https \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && touch /etc/apt/sources.list.d/pgroogna.list \
    && echo "deb [signed-by=/usr/share/keyrings/groonga-archive-keyring.gpg] https://packages.groonga.org/debian/ stretch main" >> /etc/apt/sources.list.d/pgroogna.list \
    && echo "deb-src [signed-by=/usr/share/keyrings/groonga-archive-keyring.gpg] https://packages.groonga.org/debian/ stretch main" >> /etc/apt/sources.list.d/pgroogna.list \
    && apt-get update \
    && apt-get install -y -V postgresql-11-pgroonga groonga-tokenizer-mecab \
    && rm -rf /var/lib/apt/lists/*

ENV PGROUTING_MAJOR 2.3
ENV PGROUTING_VERSION 2.3.0-1

RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-$PG_MAJOR-pgrouting && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY pgrouting/initdb-pgrouting.sh /docker-entrypoint-initdb.d/routing.sh

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

RUN apt-get update -y \
    && apt-get install -y postgresql-11-repmgr rsync \
    && rm -rf /var/lib/apt/lists/*

ARG OSSUTIL_VERSION=1.6.10
ADD http://gosspublic.alicdn.com/ossutil/${OSSUTIL_VERSION}/ossutil64 /usr/bin/
RUN chmod a+x /usr/bin/ossutil64 && \
    ln -s /usr/bin/ossutil64 /usr/bin/ossutil

ENV OSS_ENDPOINT=''
ENV OSS_AK_ID=''
ENV OSS_AK_SECRET=''
ENV OSSUTIL_CONFIG_FILE='/var/lib/postgresql/.ossutilconfig'

COPY repmgr/init-ossutil.sh /docker-entrypoint-initdb.d/init-ossutil.sh
