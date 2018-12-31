#!/bin/bash

# ----- Environment setup -----
RELEASE_DIR="/tmp/release"
WORKDIR=$(pwd)

xhost local: 
echo "Opened xhost to local connections"
export AUDIO_GROUP_CR=$(getent group audio | cut -d: -f3)
echo "Created AUDIO_GROUP_CR environment variable to ${AUDIO_GROUP_CR}"
docker-compose up -d # Run infrastructure
sleep 20

# ----- Testing and building -----
echo "Cloning repository"
docker exec -it $(docker container ls -q -l) bash -c "git clone -b $TRAVIS_BRANCH https://github.com/Class-Recorder/class-recorder"
echo "Installing dependencies"
docker exec -it $(docker container ls -q -l) bash -c "cd class-recorder && npm install && npm run install-dependencies && npm run install-dependencies-cordova"
echo "Executing test"
docker exec -it $(docker container ls -q -l) bash -c "cd class-recorder && npm run test-pc-server && npm run test-pc-frontend"
echo "Building release"
docker exec -it $(docker container ls -q -l) bash -c "cd class-recorder && npm run build"

# ----- Creating release -----
mkdir $RELEASE_DIR
cp class-recorder/class-recorder/build-binaries/class-recorder-pc.jar $RELEASE_DIR
cp class-recorder/class-recorder/build-binaries/class-recorder.apk $RELEASE_DIR
ls -l ../crecorder-pc-prod-mysql
ls -l ../crecorder-pc-prod-h2
cd ..

#Adapting docker-compose to specified tag for production docker-images
sudo add-apt-repository ppa:rmescandon/yq 
sudo apt update
sudo apt install yq -y # Install yq to modify docker-compose.yml
yq write --inplace  crecorder-pc-prod-h2/docker-compose.yml services.teacher-pc-server.image cruizba/crecorder-pc-prod:$TRAVIS_TAG
yq write --inplace  crecorder-pc-prod-mysql/docker-compose.yml services.teacher-pc-server.image cruizba/crecorder-pc-prod:$TRAVIS_TAG

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