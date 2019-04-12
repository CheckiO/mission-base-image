FROM python:3.7

ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update && \
    apt-get -y install \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        gfortran


RUN set -ex; \
    \
    wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
    \
    python get-pip.py \
        --no-cache-dir \
    ; \
    rm -f get-pip.py

RUN pip install cython numpy pandas scipy sympy

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get -y --no-install-recommends install nodejs 

RUN apt-get autoremove -y && \
    apt-get autoclean -y