FROM openjdk:11
LABEL maintainer="mcreichelt@gmail.com"
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android" \
    ANDROID_NDK_HOME="/opt/android/ndk-bundle"

ENV PATH $PATH:$ANDROID_HOME/cmdline-tools/tools/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:${ANDROID_NDK_HOME}

WORKDIR /tmp

# Install some dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update -qq && \
    apt-get install -qq -y wget curl maven ant git gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386 file libpulse0 qt5-default > /dev/null 2>&1

# Download emulator script
RUN wget --quiet --output-document=/opt/android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator && \
    chmod +x /opt/android-wait-for-emulator

# Install Android commandline tools
RUN mkdir --parents /opt/android/cmdline-tools && \
    wget --quiet --output-document=tools.zip ${ANDROID_SDK_URL} && \
    unzip -qq tools.zip && \
    mv cmdline-tools /opt/android/cmdline-tools/tools && \
    rm -Rf /tmp/*

RUN yes | sdkmanager 'tools' 'platform-tools' > /dev/null

RUN export LD_LIBRARY_PATH=$ANDROID_HOME/emulator/lib64/qt/lib/
