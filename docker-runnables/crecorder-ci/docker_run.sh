#!/bin/bash

# ----- Environment setup -----
RELEASE_DIR="/tmp/release"
WORKDIR=$(pwd)

xhost local:
echo "Opened xhost to local connections"
export AUDIO_GROUP_CR=$(getent group audio | cut -d: -f3)
export AUDIODEV=null
echo "Created AUDIO_GROUP_CR environment variable to ${AUDIO_GROUP_CR}"
docker-compose up -d # Run infrastructure
sleep 20

echo "Cloning repository"
docker exec -it crecorder-server bash -c "git clone -b $TRAVIS_BRANCH https://github.com/Class-Recorder/class-recorder"
echo "Installing dependencies"
docker exec -it crecorder-server bash -c "cd class-recorder && npm install && npm run install-dependencies && npm run install-dependencies-cordova"
echo "Start server"
docker exec -d crecorder-server bash -c "cd class-recorder && npm run dev:start-pc-server > spring-logs.txt"
while ! nc -z localhost 8000 ; do
    echo "Waiting spring app to run"
    sleep 10
done
echo "Executing test"
docker exec -it crecorder-server bash -c "cd class-recorder && npm run test-pc-server && npm run test-pc-frontend"
docker exec -it crecorder-server bash -c "cd class-recorder && cat spring-logs.txt"
echo "Building release"
docker exec -it crecorder-server bash -c "cd class-recorder && npm run build"

# ----- Creating release -----
mkdir $RELEASE_DIR
cp class-recorder/class-recorder/build-binaries/class-recorder-pc.jar $RELEASE_DIR
cp class-recorder/class-recorder/build-binaries/class-recorder.apk $RELEASE_DIR
cd ..

#Adapting docker-compose to specified tag for production docker-images
#Using yq to edit docker-compose yml files
docker run -v ${PWD}:/workdir mikefarah/yq yq write --inplace  crecorder-pc-prod-h2/docker-compose.yml services.teacher-pc-server.image cruizba/crecorder-pc-prod:$TRAVIS_TAG
docker run -v ${PWD}:/workdir mikefarah/yq yq write --inplace  crecorder-pc-prod-mysql/docker-compose.yml services.teacher-pc-server.image cruizba/crecorder-pc-prod:$TRAVIS_TAG
cat crecorder-pc-prod-h2/docker-compose.yml
cat crecorder-pc-prod-mysql/docker-compose.yml

# Zipping docker runnables for releases
zip -r $RELEASE_DIR/Docker-crecorder-pc-prod-mysql.zip crecorder-pc-prod-mysql
zip -r $RELEASE_DIR/Docker-crecorder-pc-prod-h2.zip  crecorder-pc-prod-h2
cd $WORKDIR

# Copy of produced jar to build new image
cd ../../docker-images/crecorder-pc-prod/
cp $RELEASE_DIR/class-recorder-pc.jar .

# Copy release folder in workdir
cd $WORKDIR
cp -R $RELEASE_DIR $WORKDIR
ls -l $WORKDIR/release
