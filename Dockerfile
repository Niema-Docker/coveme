# Minimal Docker image for COVEME using Debian minimal base
FROM debian:10.10-slim
MAINTAINER Niema Moshiri <niemamoshiri@gmail.com>

# prep environment
RUN apt-get update && \
    apt-get -y upgrade && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install -y build-essential bzip2 cmake default-jre dirmngr g++ libboost-all-dev libcurl4-openssl-dev libprotoc-dev libssl-dev libtbb-dev libxml2-dev make protobuf-compiler python3 python3-pip r-base r-base-dev rsync software-properties-common unzip wget && \
    ln -s $(which python3) /usr/local/bin/python && \
    ln -s $(which pip3) /usr/local/bin/pip

# install relevant Python packages
RUN pip3 install biopython

# install relevant R packages
RUN Rscript -e "install.packages('BiocManager')" && \
    Rscript -e "install.packages('devtools')" && \
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

# install FigTree v1.4.4
RUN wget -qO- "https://github.com/rambaut/figtree/releases/download/v1.4.4/FigTree_v1.4.4.tgz" | tar -zx && \
    mv FigTree* /usr/local/bin/FigTree && \
    echo -e '#!/usr/bin/env bash\nFULL_PATH=$(realpath $0)\ncd $(dirname $FULL_PATH)/FigTree\n./bin/figtree "$@"' > /usr/local/bin/figtree && \
    chmod a+x /usr/local/bin/figtree /usr/local/bin/FigTree*/bin/*

# install IQ-TREE 2 v2.1.2
RUN wget -qO- "https://github.com/iqtree/iqtree2/releases/download/v2.1.2/iqtree-2.1.2-Linux.tar.gz" | tar -zx && \
    mv iqtree-*/bin/* /usr/local/bin/ && \
    rm -rf iqtree-*

# install MEGA X v10.2.6-1
RUN wget -q "https://www.megasoftware.net/releases/megax_10.2.6-1_amd64.deb" && \
    (dpkg -i megax*.deb  || true) && \
    apt-get --fix-broken install -y && \
    rm megax*.deb

# install Minimap2 v2.21
RUN wget -qO- "https://github.com/lh3/minimap2/releases/download/v2.21/minimap2-2.21_x64-linux.tar.bz2" | tar -jx && \
    mv minimap2-*/minimap2* minimap2-*/k8 /usr/local/bin/ && \
    rm -rf minimap2-*

# install TARDiS (2021-07-19 commit)
RUN wget -qO "tardis.zip" "https://github.com/smarini/tardis-phylogenetics/archive/c214f7b298f0b4b182ed7f87ab28da2aaeb4049f.zip" && \
    unzip "tardis.zip" && \
    mv tardis-* /usr/local/bin/tardis_dir && \
    ln -s /usr/local/bin/tardis_dir/tardis /usr/local/bin/tardis && \
    rm tardis.zip

# install UShER v0.3.5
RUN cd /usr/local/bin && \
    wget -qO- "https://github.com/yatisht/usher/archive/refs/tags/v0.3.5.tar.gz" | tar -zx && \
    cd usher-* && \
    sed -i 's/sudo //g' installUbuntu.sh && \
    ./installUbuntu.sh && \
    mv build/usher build/matUtils build/matOptimize /usr/local/bin/ && \
    cd /

# install ViralMSA v1.1.16
RUN wget -O /usr/local/bin/ViralMSA.py "https://github.com/niemasd/ViralMSA/raw/1.1.16/ViralMSA.py" && \
    chmod a+x /usr/local/bin/ViralMSA.py

# install VIRULIGN v1.0.1
RUN wget -qO- "https://github.com/rega-cev/virulign/releases/download/v1.0.1/virulign-linux-64bit.tgz" | tar -zx && \
    mv virulign /usr/local/bin/

# clean up
RUN rm -rf /tmp/*
