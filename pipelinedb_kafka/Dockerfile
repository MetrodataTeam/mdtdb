FROM metrodatatech/mdtdb:11

ENV DEBIAN_FRONTEND noninteractive

COPY src/sources.list /etc/apt/sources.list
COPY src/librdkafka-0.11.6.tar.gz src/pipeline_kafka.tar.gz /tmp/
RUN apt-get -y update \
    && apt-get install -y --no-install-recommends tar curl make gcc g++ libssl-dev zlib1g-dev postgresql-server-dev-11 \
    && curl -s http://download.pipelinedb.com/apt.sh | bash \
    && apt-get -y --allow-unauthenticated install pipelinedb-postgresql-11 \
    && mkdir -p /tmp/src \
    && cd /tmp/src \
    && tar xzf /tmp/librdkafka-0.11.6.tar.gz -C /tmp/src --strip-components=1 \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && rm -rf /tmp/src/* \
    && tar xzf /tmp/pipeline_kafka.tar.gz -C /tmp/src --strip-components=1 \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/* \
    && apt-get purge -y --auto-remove curl make gcc g++ postgresql-server-dev-11 zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY create-pipelinedb.sql /docker-entrypoint-initdb.d/
COPY configure.sh /docker-entrypoint-initdb.d/
