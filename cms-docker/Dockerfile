FROM ubuntu:18.04
MAINTAINER Sihadan <def6488@gmail.com>

RUN apt-get update
RUN apt-get install build-essential openjdk-8-jdk-headless fp-compiler \
            postgresql-client python3.6 cppreference-doc-en-html \
            cgroup-lite libcap-dev zip python3-pip


ARG CMS_DIR=cms
ARG CMS_TAR=${CMS_DIR}.tar.gz
RUN wget https://github.com/cms-dev/cms/releases/download/v1.4.rc1/v1.4.rc1.tar.gz -O $CMS_TAR && \
    tar -xvf $CMS_TAR && \
    cd ${CMS_DIR} && \
    python3 prerequisites.py install && \
    usermod -a -G cmsuser root && \
    pip3 install -r requirements.txt
    python3 setup.py install

COPY cms.conf /usr/local/etc/cms.conf 

RUN pip3 install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8888 8889
WORKDIR /cms
CMD supervisord