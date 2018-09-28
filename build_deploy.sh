#!/bin/bash

set -e

SDKS=$(echo {28..21})
LATEST_SDKS=$(echo {28..26})
LATEST_PACKAGES=''; for SDK in $LATEST_SDKS; do LATEST_PACKAGES="platforms;android-${SDK} $LATEST_PACKAGES"; done

echo "SDKS = $SDKS"
echo "LATEST_SDKS = $LATEST_SDKS"
echo "LATEST_PACKAGES = $LATEST_PACKAGES"

docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD

echo "Building 'minimal' image…"
docker build --tag mreichelt/android:minimal --file minimal.Dockerfile .
docker push mreichelt/android:minimal
echo

echo "Building 'base' image…"
docker build --tag mreichelt/android:base --file base.Dockerfile .
docker push mreichelt/android:base
echo

echo "Building 'latest' image…"
docker build --tag mreichelt/android:latest --build-arg "latest_packages=${LATEST_PACKAGES}" --file latest.Dockerfile .
docker push mreichelt/android:latest
echo

docker rmi mreichelt/android:minimal mreichelt/android:latest

for sdk in $SDKS; do
    echo "Building '$sdk' image…"
    docker build --tag mreichelt/android:$sdk --build-arg android_sdk_version=$sdk --file sdk.Dockerfile .
    docker push mreichelt/android:$sdk
    echo

    echo "Building '$sdk-system' image…"
    docker build --tag mreichelt/android:$sdk-system --build-arg android_sdk_version=$sdk --file sdk-system.Dockerfile .
    docker push mreichelt/android:$sdk-system
    echo

    docker rmi mreichelt/android:$sdk mreichelt/android:$sdk-system
done
