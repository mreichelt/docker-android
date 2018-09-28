FROM mreichelt/android:base
LABEL maintainer="mcreichelt@gmail.com"

ARG android_sdk_version
# get more from `sdkmanager --list` (add '--verbose' to read long package names)
RUN yes | sdkmanager "platforms;android-${android_sdk_version}" > /dev/null
