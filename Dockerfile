# based on https://github.com/beevelop/docker-android
FROM beevelop/java

MAINTAINER Marc Reichelt <mcreichelt@gmail.com>

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

WORKDIR /opt

RUN dpkg --add-architecture i386 && \
    apt-get -qq update && \
    apt-get -qq install -y wget curl maven ant git gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386 file libqt5widgets5 && \
    wget --output-document=android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator && \
    chmod +x android-wait-for-emulator && \

    # Installs Android SDK
    mkdir android && cd android && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \

    # get more from `sdkmanager --list` (add '--verbose' to read long package names)
    yes | sdkmanager --verbose \
      'tools' \
      'platform-tools' \
      'emulator' \
      'build-tools;25.0.2' \
      'build-tools;25.0.3' \
      'platforms;android-25' \
      'extras;android;m2repository' \
      'extras;google;m2repository' \
      'extras;google;google_play_services' \
      'extras;m2repository;com;android;support;constraint;constraint-layout;1.0.0' \
      'extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1' \
      'extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2' \
      'system-images;android-25;google_apis;x86' && \

    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME
