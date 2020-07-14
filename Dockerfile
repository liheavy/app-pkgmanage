FROM fedora:30 

MAINTAINER caozhi1214@gmail.com

RUN dnf install wget gcc python3-devel vim zlib-devel psmisc findutils procps bzip2 sqlite -y
RUN pip3 install flask-session flask-script marshmallow uwsgi pyinstaller wget bs4 

WORKDIR /pkgmanage

COPY openEuler_aarch64.repo ./
COPY conf.yaml ./
COPY pkgship-*.rpm ./

#RUN pip install -r requirements
RUN dnf install pkgship-*.rpm -y
RUN dnf clean all

#COPY conf.yaml /etc/pkgship

#RUN pkgshipd start
#CMD ["pkgshipd", "start"] 

