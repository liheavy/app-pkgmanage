FROM openeuler/openeuler:22.09

MAINTAINER caozhi1214@gmail.com

WORKDIR /pkgmanage

COPY openEuler.repo /etc/yum.repos.d/
COPY conf.yaml ./
COPY pkgship-*.rpm ./
COPY redis.conf /etc/
COPY auto_setup.sh /etc/

RUN dnf update -y && dnf install python-pip pkgship-*.rpm cronie -y && dnf clean all
