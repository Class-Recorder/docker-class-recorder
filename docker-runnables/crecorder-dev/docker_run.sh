#!/bin/bash
xhost local: 
echo "Opened xhost to local connections"
export AUDIO_GROUP_CR=$(getent group audio | cut -d: -f3)
echo "Created AUDIO_GROUP_CR environment variable to ${AUDIO_GROUP_CR}"
export CURRENT_UID=$(id -u):$(id -g)
mkdir -p class-recorder/class-recorder
docker-compose up
