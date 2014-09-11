# VERSION 1.0
# DOCKER-VERSION  1.2.0
# AUTHOR:         Richard Lee <lifuzu@gmail.com>
# DESCRIPTION:    Java Image Container

FROM dockerbase/ubuntu

MAINTAINER Richad Lee "lifuzu@gmail.com"

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Information Of Package
ENV	JDK_VERSION jdk1.8.0_20
ENV	JDK_PACKAGE jdk-8u20-linux-x64.tar.gz
ENV	JDK_LINK http://download.oracle.com/otn-pub/java/jdk/8u20-b26/$JDK_PACKAGE

# Update
RUN     apt-get update

# Java
RUN     cd /tmp && \
        curl -b gpw_e24=http%3A%2F%2Fwww.oracle.com -b oraclelicense=accept-securebackup-cookie -O -L $JDK_LINK && \
        tar -zxf /tmp/$JDK_PACKAGE -C /usr/local && \
        ln -s /usr/local/$JDK_VERSION /usr/local/java

ENV     JAVA_HOME /usr/local/java
ENV     JRE_HOME /usr/local/java/jre
ENV     PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin

# clean up
RUN     apt-get clean
RUN     rm -rf /tmp/* /var/tmp/*
RUN     rm -rf /var/lib/apt/lists/*

# Set environment variables.
ENV     HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
