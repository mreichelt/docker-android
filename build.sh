#!/bin/bash

set -e

SDKS=$(seq 28 21)
LATEST_SDKS=$(seq 28 26)
LATEST_PACKAGES=''; for SDK in $LATEST_SDKS; do LATEST_PACKAGES="platforms;android-${SDK} $LATEST_PACKAGES"; done

echo "SDKS = $SDKS"
echo "LATEST_SDKS = $LATEST_SDKS"
echo "LATEST_PACKAGES = $LATEST_PACKAGES"

echo "Building 'minimal' image…"
docker build --tag mreichelt/android:minimal --file minimal.Dockerfile .
echo

echo "Building 'base' image…"
docker build --tag mreichelt/android:base --file base.Dockerfile .
echo

echo "Building 'latest' image…"
docker build --tag mreichelt/android:latest --build-arg "latest_packages=${LATEST_PACKAGES}" --file latest.Dockerfile .
echo

for sdk in $SDKS; do
    echo "Building '$sdk' image…"
    docker build --tag mreichelt/android:$sdk --build-arg android_sdk_version=$sdk --file sdk.Dockerfile .
    echo

    echo "Building '$sdk-system' image…"
    docker build --tag mreichelt/android:$sdk-system --build-arg android_sdk_version=$sdk --file sdk-system.Dockerfile .
    echo
done
