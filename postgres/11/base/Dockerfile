FROM mdillon/postgis:11
RUN localedef -f UTF-8 -i zh_CN zh_CN.UTF-8
COPY init-limits.sh /docker-entrypoint-initdb.d/
