FROM fedora:30 

MAINTAINER caozhi1214@gmail.com

RUN dnf install wget vim bzip2 sqlite git -y
RUN pip3 install wget bs4 pyyaml

WORKDIR /etc/pkgship/

COPY *.py ./

RUN dnf clean all
#RUN python3 getsqlitefile.py

#COPY conf.yaml /etc/pkgship

#RUN pkgshipd start
#CMD ["pkgshipd", "start"] 

