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

# Tools
RUN apt-get install -y doxygen doxygen-latex graphviz wget ccache rsync joe 

# Java
RUN apt-get install -y maven default-jdk binutils-i686-linux-gnu 

# Additional tools
RUN apt-get install -y libboost-all-dev bzip2 curl git-core html2text libc6-i386 libc6-dev-i386
RUN apt-get install -y lib32stdc++6 lib32gcc-s1 lib32z1 unzip openssh-client sshpass lftp 
RUN apt-get install -y libgnutls28-dev adb 
RUN apt-get install -y python3-pip

# Install wget, sudo, and .NET SDK 8.0
RUN apt-get install -y wget  && \
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-8.0


# ------------------------------------------------------
# --- Android NDK
# ------------------------------------------------------

ENV ANDROID_NDK_VERSION="r18b"
ENV ANDROID_NDK_HOME=/opt/android-ndk

# download
RUN mkdir /opt/android-ndk-tmp
WORKDIR /opt/android-ndk-tmp
RUN wget  https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip

# uncompress
RUN unzip android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
# move to its final location
RUN mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME}
# remove temp dir
RUN rm -rf /opt/android-ndk-tmp

# ------------------------------------------------------
# --- Android SDK
# ------------------------------------------------------
# must be updated in case of new versions set 
#ENV VERSION_SDK_TOOLS="4333796"
ENV VERSION_SDK_TOOLS=6858069
ENV ANDROID_HOME="/sdk"
ENV ANDROID_SDK_ROOT="/sdk"

RUN rm -rf /sdk
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_SDK_TOOLS}_latest.zip -O sdk.zip
RUN unzip sdk.zip -d /sdk 
RUN rm -v sdk.zip

RUN mkdir -p ${ANDROID_HOME}/licenses/ && echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license && echo "84831b9409646a918e30573bab4c9c91346d8abd\n504667f4c0de7af1a06de9f4b1727b84351f2910" > $ANDROID_HOME/licenses/android-sdk-preview-license

ADD packages.txt /sdk

RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg && ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --update --sdk_root=/sdk 

# accept all licences
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --licenses --sdk_root=/sdk

RUN ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --package_file=/sdk/packages.txt --sdk_root=/sdk


# ------------------------------------------------------
# --- Finishing touch
# ------------------------------------------------------


RUN mkdir /scripts
ADD scripts/get-release-notes.sh /scripts
RUN chmod +x /scripts/get-release-notes.sh

ADD scripts/adb-all.sh /scripts
RUN chmod +x /scripts/adb-all.sh

ADD scripts/compare_files.sh /scripts
RUN chmod +x /scripts/compare_files.sh

ADD scripts/lint-up.rb /scripts
ADD scripts/send_ftp.sh /scripts


# add ANDROID_NDK_HOME to PATH
ENV PATH ${PATH}:${ANDROID_NDK_HOME}

# SETTINGS FOR GRADLE 5.4.1
ADD https://services.gradle.org/distributions/gradle-5.4.1-all.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx
RUN cp /tmp/gradle-5.4.1-all.zip /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/
RUN unzip /tmp/gradle-5.4.1-all.zip -d /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/gradle-5.4.1-all.ok
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/gradle-5.4.1-all.lck
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-all/3221gyojl5jsh0helicew7rwx/gradle-5.4.1-all.zip.lck 

ADD https://services.gradle.org/distributions/gradle-5.4.1-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x
RUN cp /tmp/gradle-5.4.1-bin.zip /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x/
RUN unzip /tmp/gradle-5.4.1-bin.zip -d /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x/gradle-5.4.1-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x/gradle-5.4.1-bin.lck
RUN touch /opt/gradle/wrapper/dists/gradle-5.4.1-bin/e75iq110yv9r9wt1a6619x2x/gradle-5.4.1-bin.zip.lck


# SETTINGS FOR GRADLE 6.7
ADD https://services.gradle.org/distributions/gradle-6.7-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv
RUN cp /tmp/gradle-6.7-bin.zip /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv/
RUN unzip /tmp/gradle-6.7-bin.zip -d /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv
RUN touch /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv/gradle-6.7-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-6.7-bin/efvqh8uyq79v2n7rcncuhu9sv/gradle-6.7-bin.lck

# SETTINGS FOR GRADLE 6.7.1
ADD https://services.gradle.org/distributions/gradle-6.7.1-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6
RUN cp /tmp/gradle-6.7.1-bin.zip /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6/
RUN unzip /tmp/gradle-6.7.1-bin.zip -d /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6
RUN touch /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6/gradle-6.7.1-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-6.7.1-bin/bwlcbys1h7rz3272sye1xwiv6/gradle-6.7.1-bin.lck

# SETTINGS FOR GRADLE 7.2
ADD https://services.gradle.org/distributions/gradle-7.2-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-7.2-bin/2dnblmf4td7x66yl1d74lt32g
RUN cp /tmp/gradle-7.2-bin.zip /opt/gradle/wrapper/dists/gradle-7.2-bin/2dnblmf4td7x66yl1d74lt32g
RUN unzip /tmp/gradle-7.2-bin.zip -d /opt/gradle/wrapper/dists/gradle-7.2-bin/2dnblmf4td7x66yl1d74lt32g
RUN touch /opt/gradle/wrapper/dists/gradle-7.2-bin/2dnblmf4td7x66yl1d74lt32g/gradle-7.2-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-7.2-bin/2dnblmf4td7x66yl1d74lt32g/gradle-7.2-bin.lck

# SETTINGS FOR GRADLE 7.6
ADD https://services.gradle.org/distributions/gradle-7.6-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-7.6-bin/9l9tetv7ltxvx3i8an4pb86ye
RUN cp /tmp/gradle-7.6-bin.zip /opt/gradle/wrapper/dists/gradle-7.6-bin/9l9tetv7ltxvx3i8an4pb86ye
RUN unzip /tmp/gradle-7.6-bin.zip -d /opt/gradle/wrapper/dists/gradle-7.6-bin/9l9tetv7ltxvx3i8an4pb86ye
RUN touch /opt/gradle/wrapper/dists/gradle-7.6-bin/9l9tetv7ltxvx3i8an4pb86ye/gradle-7.6-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-7.6-bin/9l9tetv7ltxvx3i8an4pb86ye/gradle-7.6-bin.lck

# SETTINGS FOR GRADLE 8.7
ADD https://services.gradle.org/distributions/gradle-8.7-bin.zip /tmp
RUN mkdir -p /opt/gradle/wrapper/dists/gradle-8.7-bin/bhs2wmbdwecv87pi65oeuq5iu
RUN cp /tmp/gradle-8.7-bin.zip /opt/gradle/wrapper/dists/gradle-8.7-bin/bhs2wmbdwecv87pi65oeuq5iu
RUN unzip /tmp/gradle-8.7-bin.zip -d /opt/gradle/wrapper/dists/gradle-8.7-bin/bhs2wmbdwecv87pi65oeuq5iu
RUN touch /opt/gradle/wrapper/dists/gradle-8.7-bin/bhs2wmbdwecv87pi65oeuq5iu/gradle-8.7-bin.ok
RUN touch /opt/gradle/wrapper/dists/gradle-8.7-bin/bhs2wmbdwecv87pi65oeuq5iu/gradle-8.7-bin.lck

ENV GRADLE_HOME=/opt/gradle/gradle-8.7/bin

# install selenium + chrome
#RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#RUN apt install ./google-chrome-stable_current_amd64.deb
#RUN python3 -m pip install --upgrade pip
#RUN pip install selenium


# add ccache to PATH
ENV PATH=/usr/lib/ccache:${GRADLE_HOME}:${PATH}

ENV CCACHE_DIR /mnt/ccache
ENV NDK_CCACHE /usr/bin/ccache
