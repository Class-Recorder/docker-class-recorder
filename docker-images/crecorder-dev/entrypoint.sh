#!/bin/sh

alias dev-start-pc-server="npm run dev:start-pc-server"
alias dev-start-pc-frontend="npm run dev:start-pc-frontend"
alias dev-start-mobile-serve="npm run dev:start-mobile-serve"
alias dev-start-mobile-device="dev:start-mobile-device"

echo "Cloning repository"
git clone https://github.com/Class-Recorder/class-recorder
cd class-recorder
echo "Installing dependencies"

npm install
npm run install-dependencies
npm run install-dependencies-cordova

echo "Development environment is up"
echo "List of commands2"
echo $text

tail -f /dev/null