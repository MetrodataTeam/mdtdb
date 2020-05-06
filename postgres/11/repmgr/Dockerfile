FROM mdillon/postgis:11

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

COPY init-ossutil.sh /docker-entrypoint-initdb.d/init-ossutil.sh
