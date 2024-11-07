# Pull the Gradle image (if you don't already have it)
docker pull gradle:8.3-jdk17

#!/bin/bash

# Get the home directory in an OS-independent way
if [ -n "$HOME" ]; then
  HOMEDIR="$HOME"
elif [ -n "$USERPROFILE" ]; then
  HOMEDIR="$USERPROFILE"
else
  echo "Unable to determine home directory"
  exit 1
fi

echo "Home directory: $HOMEDIR"

#!/bin/bash

# Define the local path where Gradle will be extracted
GRADLE_DIR="$HOME/gradle"

# Check if the Gradle directory already exists
if [ ! -d "$GRADLE_DIR" ]; then
  echo "Gradle not found, extracting from Docker..."

  # Use Docker to extract Gradle if it's not present locally
  docker run --rm -v "$HOME":/mnt gradle:8.3-jdk17 bash -c "cp -r /opt/gradle /mnt/gradle"

  # Check if extraction was successful
  if [ $? -eq 0 ]; then
    echo "Gradle extracted successfully."
  else
    echo "Failed to extract Gradle."
    exit 1
  fi
else
  echo "Gradle already exists at $GRADLE_DIR. Skipping extraction."
fi



# Create a temporary container, extract Gradle, and copy it to the host machine
docker run --rm -v "$HOMEDIR":/mnt gradle:8.3-jdk17 bash -c "cp -r /opt/gradle /mnt/gradle"

export GRADLE_HOME=$HOMEDIR/gradle/gradle-8.3
export PATH=$GRADLE_HOME/bin:$PATH
source ~/.bashrc  # or ~/.zshrc, depending on your shell
gradle --version
