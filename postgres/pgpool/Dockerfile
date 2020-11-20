FROM centos:8
ARG PGPOOL_VERSION='4.0.11'
RUN dnf install -y http://www.pgpool.net/yum/rpms/4.0/redhat/rhel-8-x86_64/pgpool-II-pg12-${PGPOOL_VERSION}-1pgdg.rhel8.x86_64.rpm && \
    dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    dnf -qy module disable postgresql && \
    dnf install -y pgpool-II-pg12 postgresql12
