# Minimal Docker image for COVEME using Debian minimal base
FROM debian:10.10-slim
MAINTAINER Niema Moshiri <niemamoshiri@gmail.com>

# prep environment
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential cmake default-jre dirmngr g++ libboost-all-dev libprotoc-dev libtbb-dev make protobuf-compiler rsync software-properties-common unzip wget && \
    ln -s $(which python3) /usr/local/bin/python

# install R and relevant R packages
RUN wget -qO- "https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc" >> /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y r-base && \
    Rscript -e "install.packages('devtools')" && \
    Rscript -e "install.packages('BiocManager')" && \
    Rscript -e "install.packages('doRNG')" && \
    Rscript -e "install.packages('dplyr')" && \
    Rscript -e "install.packages('ggplot2')" && \
    Rscript -e "install.packages('gridExtra')" && \
    Rscript -e "install.packages('optparse')" && \
    Rscript -e "install.packages('shiny')" && \
    Rscript -e "devtools::install_github('wleepang/shiny-directory-input')" && \
    Rscript -e "BiocManager::install('DECIPHER')"

# install NextFlow
RUN wget -qO- "https://get.nextflow.io" | bash && \
    mv nextflow /usr/local/bin/

# install IQ-TREE 2 v2.1.2
RUN wget -qO- "https://github.com/iqtree/iqtree2/releases/download/v2.1.2/iqtree-2.1.2-Linux.tar.gz" | tar -zx && \
    mv iqtree-*/bin/* /usr/local/bin/ && \
    rm -rf iqtree-*

# install MEGA X v10.2.6-1
RUN wget -q "https://www.megasoftware.net/releases/megax_10.2.6-1_amd64.deb" && \
    dpkg -i megax*.deb && \
    apt-get --fix-broken install -y && \
    rm megax*.deb

# install TARDiS (2021-07-19 commit)
RUN wget -qO "tardis.zip" "https://github.com/smarini/tardis-phylogenetics/archive/c214f7b298f0b4b182ed7f87ab28da2aaeb4049f.zip" && \
    unzip "tardis.zip" && \
    mv tardis-* /usr/local/bin/tardis_dir && \
    ln -s /usr/local/bin/tardis_dir/tardis /usr/local/bin/tardis && \
    rm tardis.zip

# install VIRULIGN v1.0.1
RUN wget -qO- "https://github.com/rega-cev/virulign/releases/download/v1.0.1/virulign-linux-64bit.tgz" | tar -zx && \
    mv virulign /usr/local/bin/

# clean up
RUN rm -rf /tmp/*
