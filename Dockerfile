FROM opensourceway/openeuler:20.09beta

MAINTAINER caozhi1214@gmail.com

WORKDIR /pkgmanage

COPY openEuler.repo /etc/yum.repos.d/
COPY conf.yaml ./
COPY pkgship-*.rpm ./

RUN dnf update
RUN dnf install pkgship-*.rpm -y
RUN dnf clean all

#COPY conf.yaml /etc/pkgship

#RUN pkgshipd start
#CMD ["pkgshipd", "start"] 

