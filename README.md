# Docker images for Android development

[![Build Status](https://travis-ci.org/mreichelt/docker-android.svg?branch=master)](https://travis-ci.org/mreichelt/docker-android)

You want to build Android apps on your CI server or just play around with certain Android SDKs?
Then these Docker images could come in very handy!

They are all built and automatically published on [Dockerhub](https://hub.docker.com/r/mreichelt/android/) -
check out the list of [tags](https://hub.docker.com/r/mreichelt/android/tags/) available.

## Getting started

To play around with an image locally, install [Docker](https://www.docker.com/) and run one of these commands:

```bash
# run the minimal image (just Java + sdkmanager)
docker run --rm -it mreichelt/android:minimal

# or run an image with SDK 28 installed
docker run --rm -it mreichelt/android:28

# this one also contains the emulator + system image:
docker run --rm -it mreichelt/android:28-system

# or, if you want the newest 3 SDKs (currently 28, 27 and 26):
docker run --rm -it mreichelt/android:latest
```

Check out the list of [tags](https://hub.docker.com/r/mreichelt/android/tags/) and choose the Docker image you need.

## Getting started on GitLab

If you use GitLab, you can set up builds for your Android app in a jiffy. Just add the following `.gitlab-ci.yml` file to your project:

```yaml
image: mreichelt/android:28

build:
  stage: build
  script:
    - ./gradlew check assemble
```

That's it! Happy hacking! 😊

## Getting Started on CircleCi

To set up CircleCi builds for your android project based on these images copy the [CircleCI recipe](/recipes/circle-ci/config.yml) into `.circleci/config.yml` of your project - happy building 🎉.

## Contributing

Pull requests are welcome! 🎉

Also, check out the [issues](https://github.com/mreichelt/docker-android/issues) to create bugreports, feature requests, etc.

## Support

Check out if your [issue](https://github.com/mreichelt/docker-android/issues) is already resolved, or create a [new support request](https://github.com/mreichelt/docker-android/issues/new). Or just ping me on [Twitter](https://twitter.com/mreichelt)!

Also, I'd love to know what you are using it for and how you like it!

## Maintainers

- [Marc Reichelt](https://github.com/mreichelt)
- Yes, I'm actively looking for maintainers 🔭! Drop me a mail if you're interested!
