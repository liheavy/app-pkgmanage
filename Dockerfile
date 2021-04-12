FROM gongzt/openeuler-21.03-x86

MAINTAINER caozhi1214@gmail.com

WORKDIR /pkgmanage

COPY openEuler.repo /etc/yum.repos.d/
COPY conf.yaml ./

COPY pkgship-*.rpm ./

RUN dnf update -y
RUN dnf install pkgship-*.rpm -y
RUN dnf install redis -y
RUN dnf install elasticsearch-7.10.1 -y
COPY redis.conf /etc/
COPY auto_setup.sh /etc/
RUN dnf clean all

#CMD ["pkgshipd","start"]
#CMD ["/usr/bin/redis-server"]
