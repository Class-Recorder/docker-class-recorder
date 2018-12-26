#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker build docker-images/crecorder-base -t cruizba/crecorder-base
docker push cruizba/crecorder-base