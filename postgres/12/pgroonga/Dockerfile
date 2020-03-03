FROM kartoza/postgis:12.1
RUN localedef -f UTF-8 -i zh_CN zh_CN.UTF-8

# https://pgroonga.github.io/install/debian.html
RUN apt install -y -V wget &&\
    wget https://packages.groonga.org/debian/groonga-archive-keyring-latest-buster.deb && \
    apt install -y -V ./groonga-archive-keyring-latest-buster.deb && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    wget -O /usr/share/keyrings/groonga-archive-keyring.gpg https://packages.groonga.org/debian/groonga-archive-keyring.gpg && \
    apt update && \
    apt install -y -V postgresql-12-pgroonga && \
    rm -rf /var/lib/apt/lists/*
