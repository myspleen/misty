FROM postgres:15-bookworm

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# PGroonga install
ENV PGROONGA_VERSION=3.1.1-1
RUN apt update && apt install -y -V wget curl gnupg && \
    curl -fsSL https://packages.groonga.org/debian/groonga-apt-source-latest-bookworm.deb -o groonga-apt-source-latest-bookworm.deb && \
    apt install -y -V ./groonga-apt-source-latest-bookworm.deb && \
    rm groonga-apt-source-latest-bookworm.deb && \
    apt update && \
    apt install -y -V \
        postgresql-15-pgdg-pgroonga=${PGROONGA_VERSION} \
        groonga-normalizer-mysql \
        groonga-token-filter-stem \
        groonga-tokenizer-mecab && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# pg_rman install
RUN apt update
RUN apt install -y build-essential libpq-dev git zlib1g-dev
RUN apt-get update
RUN apt-get -y install postgresql-client-15 postgresql-15 postgresql-server-dev-15 libpq-dev libarrow-dev
RUN apt-get -y install libpq-dev libselinux1-dev liblz4-dev libpam0g-dev libkrb5-dev libreadline-dev libzstd-dev

RUN git clone https://github.com/ossc-db/pg_rman.git /tmp/pg_rman && \
    cd /tmp/pg_rman && \
    make && make install && \
    rm -rf /tmp/pg_rman

# rsync install
RUN apt-get update && apt-get install -y rsync

# pigz
RUN apt-get update && apt-get install -y \
    pigz \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/lib/x86_64-linux-gnu/libarrow.so.1601 /usr/lib/x86_64-linux-gnu/libarrow.so.1600 && ldconfig

CMD ["docker-entrypoint.sh", "postgres"]
