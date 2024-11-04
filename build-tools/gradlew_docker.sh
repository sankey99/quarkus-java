#! /usr/bin/env bash
docker run --rm -v "$PWD":/app -w /app gradle-openjdk21 gradle build
