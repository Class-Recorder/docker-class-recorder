#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker build docker-images/crecorder-base -t cruizba/crecorder-base
docker build docker-images/crecorder-dev -t cruizba/crecorder-dev
docker build docker-images/crecorder-ci -t cruizba/crecorder-ci
docker push cruizba/crecorder-base
docker push cruizba/crecorder-dev
docker push cruizba/crecorder-ci