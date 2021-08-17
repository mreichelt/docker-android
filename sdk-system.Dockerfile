ARG android_sdk_version
FROM mreichelt/android:${android_sdk_version}
LABEL maintainer="mcreichelt@gmail.com"

ARG android_sdk_version
# get more from `sdkmanager --list` (add '--verbose' to read long package names)
RUN yes | sdkmanager \
    'emulator' \
    "system-images;android-${android_sdk_version};google_apis;x86_64" > /dev/null
