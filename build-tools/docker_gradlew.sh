#!/bin/bash

# Custom Docker image containing Gradle and Java
DOCKER_IMAGE="your-docker-image"

# Function to convert paths for Docker compatibility
convert_path() {
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    # Convert Unix-style paths to Windows-style if on Windows (Git Bash)
    cygpath -w "$1"
  else
    # On Linux or other Unix-like OSes, return the path unchanged
    echo "$1"
  fi
}

# Detect if running in Windows (Git Bash) or Linux
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  echo "Running on Windows (Git Bash)..."
else
  echo "Running on Linux..."
fi

# Local directories to mount into the container
PROJECT_DIR=$(pwd)
MAVEN_LOCAL_REPO="$HOME/.m2"
GRADLE_CACHE="$HOME/.gradle"
MAVEN_SETTINGS="$HOME/.m2/settings.xml"

# Convert paths if running on Windows (Git Bash)
PROJECT_DIR_DOCKER=$(convert_path "$PROJECT_DIR")
MAVEN_LOCAL_REPO_DOCKER=$(convert_path "$MAVEN_LOCAL_REPO")
GRADLE_CACHE_DOCKER=$(convert_path "$GRADLE_CACHE")
MAVEN_SETTINGS_DOCKER=$(convert_path "$MAVEN_SETTINGS")

# Output the converted paths for debugging
echo "Project directory (Docker): $PROJECT_DIR_DOCKER"
echo "Maven local repo (Docker): $MAVEN_LOCAL_REPO_DOCKER"
echo "Gradle cache (Docker): $GRADLE_CACHE_DOCKER"
echo "Maven settings (Docker): $MAVEN_SETTINGS_DOCKER"

# Run the Gradle command inside the Docker container
docker run --rm \
    -v "$PROJECT_DIR_DOCKER":/home/gradle/project \
    -v "$MAVEN_LOCAL_REPO_DOCKER":/root/.m2 \
    -v "$GRADLE_CACHE_DOCKER":/home/gradle/.gradle \
    -v "$MAVEN_SETTINGS_DOCKER":/root/.m2/settings.xml \
    -w /home/gradle/project \
    "$DOCKER_IMAGE" gradle "$@"