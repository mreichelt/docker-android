#!/bin/bash

# abort on errors and on unset variables
set -e -o nounset

SDKS=$(echo {28..21})
LATEST_SDKS=$(echo {28..26})
LATEST_PACKAGES=''; for SDK in $LATEST_SDKS; do LATEST_PACKAGES="platforms;android-${SDK} $LATEST_PACKAGES"; done

echo "SDKS = $SDKS"
echo "LATEST_SDKS = $LATEST_SDKS"
echo "LATEST_PACKAGES = $LATEST_PACKAGES"

docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD

build_deploy_minimal() {
    echo "Building 'minimal' image…"
    docker build --tag mreichelt/android:minimal --file minimal.Dockerfile .
    docker push mreichelt/android:minimal
    echo
}

build_deploy_base() {
    echo "Building 'base' image…"
    docker build --tag mreichelt/android:base --file base.Dockerfile .
    docker push mreichelt/android:base
    echo
}

build_deploy_latest() {
    echo "Building 'latest' image…"
    docker build --tag mreichelt/android:latest --build-arg "latest_packages=${LATEST_PACKAGES}" --file latest.Dockerfile .
    docker push mreichelt/android:latest
    echo
}

build_deploy_sdk_and_system() {
    sdk=$1

    echo "Building '$sdk' image…"
    docker build --tag mreichelt/android:$sdk --build-arg android_sdk_version=$sdk --file sdk.Dockerfile .
    docker push mreichelt/android:$sdk
    echo

    echo "Building '$sdk-system' image…"
    docker build --tag mreichelt/android:$sdk-system --build-arg android_sdk_version=$sdk --file sdk-system.Dockerfile .
    docker push mreichelt/android:$sdk-system
    echo

    docker rmi mreichelt/android:$sdk mreichelt/android:$sdk-system
}

build_deploy_minimal
build_deploy_base
build_deploy_latest

# remove some old images to save space on Travis CI
docker rmi mreichelt/android:minimal mreichelt/android:latest

# build all sdk + system variants (in parallel because TravisCI has a 50m timeout)
export -f build_deploy_sdk_and_system
SHELL=$(type -p bash) parallel -j 3 build_deploy_sdk_and_system {} ::: $SDKS
