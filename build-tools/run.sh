#!/usr/bin/env bash

docker run --rm -v "$PWD":/app -w /app gradle-graalvm-jdk21 java -jar $1
