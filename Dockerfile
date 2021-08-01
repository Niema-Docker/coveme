# Minimal Docker image for COVEME using Ubuntu base
FROM ubuntu:20.10
MAINTAINER Niema Moshiri <niemamoshiri@gmail.com>

# prep environment
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y wget

# install IQ-TREE 2
RUN wget -qO- "https://github.com/iqtree/iqtree2/releases/download/v2.1.2/iqtree-2.1.2-Linux.tar.gz" | tar -zx && \
    mv iqtree-*/bin/* /usr/local/bin/ && \
    rm -rf iqtree-*
