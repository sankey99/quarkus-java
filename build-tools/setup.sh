# Pull the Gradle image (if you don't already have it)
docker pull gradle:8.3-jdk17

# Create a temporary container, extract Gradle, and copy it to the host machine
docker run --rm -v "$PWD":/mnt gradle:8.3-jdk17 bash -c "cp -r /opt/gradle /mnt/gradle"

export GRADLE_HOME=$PWD/gradle/gradle-8.3
export PATH=$GRADLE_HOME/bin:$PATH
source ~/.bashrc  # or ~/.zshrc, depending on your shell
gradle --version
