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
