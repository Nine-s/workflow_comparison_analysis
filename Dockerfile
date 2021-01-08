# Set the base image to debian jessie
#FROM debian:jessie
FROM ubuntu:18.04
# File Author / Maintainer
LABEL key=" Ninon De Mecquenem <mecquenn@informatik.hu-berlin.de>"
RUN apt-get update && apt-get install --yes --no-install-recommends \
    wget \
    locales \
    vim-tiny \
    git \
    cmake \
    build-essential \
    gcc-multilib \
    zip \
    unzip \
    bash \
    git \
    default-jre \
    openjdk-11-jre-headless \
    openjdk-8-jre-headless \
    default-jre

RUN apt-get clean && apt-get update && apt-get install -y \
    locales \
    language-pack-fi  \
    language-pack-en && \
    export LANGUAGE=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8 && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales


# This doesn't solve either
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment     && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen     && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf     && \
    locale-gen en_US.UTF-8

# fastqc: https://github.com/gawbul/docker-fastqc/blob/master/Dockerfile
# RUN mkdir -p /opt/tools
# WORKDIR /opt/tools
# RUN \
#     wget -c http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip && \
#     unzip fastqc_v0.11.5.zip && \
#     cd FastQC && \
#     chmod +x fastqc && \
#     cp -r fastqc /usr/local/bin
# fastp
RUN \
    wget http://opengene.org/fastp/fastp && \
    chmod a+x ./fastp && \
    cp -r fastp /usr/local/bin
# sortmerna
RUN \
    apt-get update && \
    apt-get install -y fastqc && \
    apt-get install -y sortmerna && \
    apt-get install -y hisat2 && \
    apt-get install -y samtools && \
    apt-get install -y cufflinks 

# bowtie2
#RUN \
#    apt install sudo apt-get install -y bwa
# tophat
# sudo apt-get install cufflinks 
# iReckon

#install boost



# $ sudo apt install libboost-dev
# $ sudo apt install libboost-all-dev
# OR
# git clone --recursive https://github.com/boostorg/boost.git
# cd boost
# git checkout develop # or whatever branch you want to use
# ./bootstrap.sh
# ./b2 headers


#eigen libraries: sudo apt install libeigen3-dev