FROM python:3.8-rc

ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update && \
    apt-get -y install \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        gfortran \
        python-dev

RUN pip install cython
RUN pip install git+https://github.com/numpy/numpy
RUN pip install git+https://github.com/pandas-dev/pandas
# RUN pip install git+https://github.com/scipy/scipy
RUN pip install scipy
RUN pip install git+https://github.com/sympy/sympy.git

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get -y --no-install-recommends install nodejs 

RUN apt-get autoremove -y && \
    apt-get autoclean -y