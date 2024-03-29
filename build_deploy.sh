#!/bin/bash

# abort on errors and on unset variables
set -e -o nounset

SDKS=$(echo {31..31})
LATEST_SDKS=$(echo {31..29})
LATEST_PACKAGES=''; for SDK in $LATEST_SDKS; do LATEST_PACKAGES="platforms;android-${SDK} $LATEST_PACKAGES"; done
PARALLEL=false
DRY_RUN=false

echo "SDKS = $SDKS"
echo "LATEST_SDKS = $LATEST_SDKS"
echo "LATEST_PACKAGES = $LATEST_PACKAGES"

docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD

docker_push() {
  if $DRY_RUN; then
    echo "Dry run: docker push $1"
  else
    docker push $1
  fi
}

build_deploy_minimal() {
    echo "Building 'minimal' image…"
    docker build --tag mreichelt/android:minimal --file minimal.Dockerfile .
    docker_push mreichelt/android:minimal
    echo
}

build_deploy_base() {
    echo "Building 'base' image…"
    docker build --tag mreichelt/android:base --file base.Dockerfile .
    docker_push mreichelt/android:base
    echo
}

build_deploy_base_ndk() {
    echo "Building 'base-ndk' image…"
    docker build --tag mreichelt/android:base-ndk --file base-ndk.Dockerfile .
    docker_push mreichelt/android:base-ndk
    echo
}

build_deploy_latest() {
    echo "Building 'latest' image…"
    docker build --tag mreichelt/android:latest --build-arg "latest_packages=${LATEST_PACKAGES}" --file latest.Dockerfile .
    docker_push mreichelt/android:latest
    echo
}

build_deploy_latest_ndk() {
    echo "Building 'latest-ndk' image…"
    docker build --tag mreichelt/android:latest-ndk --file latest-ndk.Dockerfile .
    docker_push mreichelt/android:latest-ndk
    echo
}

build_deploy_sdk_and_system() {
    sdk=$1

    echo "Building '$sdk' image…"
    docker build --tag mreichelt/android:$sdk --build-arg android_sdk_version=$sdk --file sdk.Dockerfile .
    echo "Pushing '$sdk' image…"
    docker_push mreichelt/android:$sdk
    echo

    echo "Building '$sdk-system' image…"
    docker build --tag mreichelt/android:$sdk-system --build-arg android_sdk_version=$sdk --file sdk-system.Dockerfile .
    echo "Pushing '$sdk-system' image…"
    docker_push mreichelt/android:$sdk-system
    echo

    echo "Deleting images '$sdk' and '$sdk-system'"
    docker rmi mreichelt/android:$sdk mreichelt/android:$sdk-system
}

build_deploy_minimal
build_deploy_base
build_deploy_latest
build_deploy_base_ndk
build_deploy_latest_ndk

# build all sdk + system variants (in parallel because TravisCI has a 50m timeout)
case $PARALLEL in
  (true)
    export -f build_deploy_sdk_and_system
    SHELL=$(type -p bash) parallel -j 2 --keep-order --line-buffer echo Building SDK {}\; build_deploy_sdk_and_system {} ::: $SDKS
    ;;
  (false)
    for SDK in $SDKS; do
      echo Building SDK $SDK
      build_deploy_sdk_and_system $SDK
    done
    ;;
esac
