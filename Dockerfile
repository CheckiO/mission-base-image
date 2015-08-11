FROM debian:jessie
MAINTAINER Igor Lubimov <igor@checkio.org>


ENV PYTHON_VERSION 3.4.3
ENV NODE_VERSION 0.12.4
ENV NPM_VERSION 2.11.1

ENV REQUIREMENTS "curl  gcc libc6-dev libsqlite3-dev libssl-dev make xz-utils zlib1g-dev"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# remove several traces of debian python
RUN apt-get purge -y python.*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        $REQUIREMENTS \
        git \
        ca-certificates \
        libsqlite3-0 \
        libssl1.0.0 \
        locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.utf8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

RUN mkdir -p /usr/src/python && \
    curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" \
    | tar -xJC /usr/src/python --strip-components=1 && \
    cd /usr/src/python && \
    ./configure --enable-shared && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    curl -SL 'https://bootstrap.pypa.io/get-pip.py' | python3 && \
    find /usr/local \
    \( -type d -a -name test -o -name tests \) \
    -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
    -exec rm -rf '{}' + && \
    rm -rf /usr/src/python

RUN pip install -U pip


# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" && \
    curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" && \
    gpg --verify SHASUMS256.txt.asc && \
    grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - && \
    tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 && \
    rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc && \
    npm install -g npm@"$NPM_VERSION" && \
    npm cache clear

RUN apt-get purge -y --auto-remove $REQUIREMENTS
