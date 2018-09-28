FROM openjdk:8
LABEL maintainer="mcreichelt@gmail.com"

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

WORKDIR /opt

RUN dpkg --add-architecture i386 && \
    apt-get -qq update && \
    apt-get -qq install -y wget curl maven ant git gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386 file libpulse0 qt5-default && \
    wget --output-document=android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator && \
    chmod +x android-wait-for-emulator && \
    # Installs Android SDK
    mkdir android && cd android && \
    wget --output-document=tools.zip --show-progress ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip

RUN yes | sdkmanager --verbose 'tools' 'platform-tools'

RUN export LD_LIBRARY_PATH=$ANDROID_HOME/emulator/lib64/qt/lib/
