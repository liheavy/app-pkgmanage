FROM openeuler/openeuler:22.03-lts

MAINTAINER caozhi1214@gmail.com

WORKDIR /pkgmanage

COPY openEuler.repo /etc/yum.repos.d/
COPY conf.yaml ./

COPY pkgship-*.rpm ./

RUN dnf update -y
RUN dnf install python-pip -y
RUN dnf install pkgship-*.rpm -y
RUN dnf remove python3-simplejson -y
RUN dnf install cronie -y
COPY redis.conf /etc/
COPY auto_setup.sh /etc/
RUN dnf clean all