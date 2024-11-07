#!/bin/bash

# Define the current working directory (local project)
PROJECT_DIR=$(pwd)

# Ensure the gradle wrapper script is executable
chmod +x gradlew

# Run Gradle build using Docker for the environment, but run the build locally
docker run --rm \
    -v "$PROJECT_DIR:/app" \
    -w /app \  # Set working directory inside the container
    your-docker-image gradle build  # Run gradle build (local execution)
