FROM ubuntu:18.04
MAINTAINER Sihadan <def6488@gmail.com>

ENV USER root
ENV SHELL /bin/sh
ENV LOGNAME root
ENV LC_ALL=C.UTF-8

RUN apt-get update
RUN apt-get install wget build-essential openjdk-8-jdk-headless fp-compiler \
            postgresql-client python3.6 cppreference-doc-en-html \
            cgroup-lite libcap-dev zip python3-pip \
            python3.6-dev libpq-dev libcups2-dev libyaml-dev \
            libffi-dev -y

ARG CMS_DIR=cms
ARG CMS_TAR=${CMS_DIR}.tar.gz
RUN wget https://github.com/cms-dev/cms/releases/download/v1.4.rc1/v1.4.rc1.tar.gz -O ${CMS_TAR} && \
    tar -xvf ${CMS_TAR} && \
    cd ${CMS_DIR} && \
    python3 prerequisites.py --as-root install && \
    usermod -a -G cmsuser root && \
    pip3 install -r requirements.txt && \
    python3 setup.py install

COPY wait-for-it.sh /cms
COPY run-cms.sh /cms

RUN pip3 install supervisor
COPY conf/supervisord.conf /usr/local/etc/supervisord.conf

EXPOSE 8888 8889 9001
WORKDIR /cms
CMD supervisord
