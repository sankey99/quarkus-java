#!/usr/bin/env bash
#docker build -t <image-name>:<tag> -f <path-to-dockerfile> <context>
docker build -t gradle-graalvm-jdk21:latest -f ./docker/Dockerfile_graalvm .