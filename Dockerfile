FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y build-essential
RUN apt-get install -y devscripts cmake gcc g++ debhelper 
RUN apt-get install -y dh-exec pkg-config libboost-dev libboost-filesystem-dev 
RUN apt-get install -y libasound2-dev libgles2-mesa-dev
RUN apt-get install -y gcc-multilib g++-multilib
RUN apt-get install -y libtool autoconf
RUN apt-get install -y git joe ccache rsync
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y uuid-dev
RUN apt-get install -y qt6-base-dev
RUN apt-get install -y zlib1g-dev zip unzip
RUN apt-get install -y libxext-dev libz3-dev

#RUN apt-get install -y libboost-all-dev bzip2 curl git-core html2text libc6-i386 libc6-dev-i386
#RUN apt-get install -y lib32stdc++6 lib32gcc1 lib32z1 unzip openssh-client sshpass lftp 
#RUN apt-get install -y doxygen doxygen-latex graphviz wget ccache rsync joe 
#RUN apt-get install -y maven default-jdk binutils-i686-linux-gnu 
#RUN apt-get install -y libgnutls28-dev adb 
#RUN apt-get install -y python3-pip

