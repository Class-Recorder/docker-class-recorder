#!/bin/bash
xhost local: 
echo "Opened xhost to local connections"
export AUDIO_GROUP_CR=$(getent group audio | cut -d: -f3)
echo "Created AUDIO_GROUP_CR environment variable to ${AUDIO_GROUP_CR}"
export CURRENT_UID=$(id -u):$(id -g)
echo $CURRENT_UID
mkdir -p class-recorder/class-recorder
docker-compose up -d
sleep 20

docker exec -it $(docker container ls -q -l) bash -c "export HOME=/home/travis/build/Class-Recorder/class-recorder"
docker exec -it $(docker container ls -q -l) bash -c "echo $HOME"

echo "Cloning repository"
docker exec -it $(docker container ls -q -l) bash -c "git clone -b $TRAVIS_BRANCH https://github.com/Class-Recorder/class-recorder"
echo "Installing dependencies"
docker exec -it $(docker container ls -q -l) bash -c "cd class-recorder && ls -l && npm install && npm run install-dependencies && npm run install-dependencies-cordova"
docker exec -it $(docker container ls -q -l) bash -c "cd class-recorder && ls -l"
echo "Executing test"
docker exec -it $(docker container ls -q -l) bash -c "cd class-recorder && npm run test-pc-server && npm run test-pc-frontend && npm run build"