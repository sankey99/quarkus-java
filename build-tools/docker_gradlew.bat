@echo off
setlocal enabledelayedexpansion

:: Get the project directory (current working directory)
set PROJECT_DIR=%cd%

:: Convert Windows path to Docker-compatible Unix-style path
set PROJECT_DIR_UNIX=%PROJECT_DIR:\=/%

:: Print the project directory in Docker format for debugging
echo Project directory (Docker format): %PROJECT_DIR_UNIX%

:: Ensure gradlew is executable (on Windows, this should not be an issue, as gradlew is a shell script)
:: If necessary, you could run chmod on Linux environments, but Windows typically doesn't require it.

:: Run Gradle build using Docker, but build locally
docker run --rm ^
    -v "%PROJECT_DIR_UNIX%:/app" ^   :: Mount the local directory to /app in the container
    -w /app ^  :: Set working directory inside the container to /app
    your-docker-image ./gradlew build   :: Run the Gradle build using gradlew locally

endlocal
