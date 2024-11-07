#!/bin/bash

# Docker image with Gradle and Java
DOCKER_IMAGE="gradle:8.5-jdk21"

# Local directories to mount into the container
PROJECT_DIR=$(pwd)
MAVEN_LOCAL_REPO="$HOME/.m2"
GRADLE_CACHE="$HOME/.gradle"

# Maven settings.xml (if using)
MAVEN_SETTINGS="$HOME/.m2/settings.xml"

# Pass proxy credentials or other environment variables as needed
# PROXY_USER and PROXY_PASSWORD can be exported in the environment if necessary
# Add `-e` options if required, e.g., `-e PROXY_USER=$PROXY_USER -e PROXY_PASSWORD=$PROXY_PASSWORD`

docker run --rm \
    -v "$PROJECT_DIR":/home/gradle/project \
    -v "$MAVEN_LOCAL_REPO":/root/.m2 \
    -v "$GRADLE_CACHE":/home/gradle/.gradle \
    -v "$MAVEN_SETTINGS":/root/.m2/settings.xml \
    -w /home/gradle/project \
    "$DOCKER_IMAGE" gradle "$@"
