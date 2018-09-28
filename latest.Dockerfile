FROM mreichelt/android:base
LABEL maintainer="mcreichelt@gmail.com"

ARG latest_packages
RUN echo "Installing ${latest_packages}…"
# get more from `sdkmanager --list` (add '--verbose' to read long package names)
RUN yes | sdkmanager --verbose ${latest_packages}
