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


# Create a temporary container, extract Gradle, and copy it to the host machine
docker run --rm -v "$HOMEDIR":/mnt gradle:8.3-jdk17 bash -c "cp -r /opt/gradle /mnt/gradle"

export GRADLE_HOME=$HOMEDIR/gradle/gradle-8.3
export PATH=$GRADLE_HOME/bin:$PATH
source ~/.bashrc  # or ~/.zshrc, depending on your shell
gradle --version
