#!/bin/sh

echo "Cloning repository"
git clone https://github.com/Class-Recorder/class-recorder
cd class-recorder
echo "Installing dependencies"

npm install
npm run install-dependencies
npm run install-dependencies-cordova

echo "Development environment is up"

tail -f /dev/null