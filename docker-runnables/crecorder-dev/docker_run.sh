xhost -local: 
echo "Opened xhost to local connections"
export AUDIO_GROUP_CR=$(getent group audio | cut -d: -f3)
echo "Created AUDIO_GROUP_CR environment variable to ${AUDIO_GROUP_CR}"
docker run -it \
    -v $PWD/../..:/home/userdocker/class-recorder \
    -v $XDG_RUNTIME_DIR/pulse/native:$XDG_RUNTIME_DIR/pulse/native \
    -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
    -e DISPLAY=$DISPLAY \
    -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
    --network host \
    --group-add $AUDIO_GROUP_CR \
    --name crdev crecorder-dev
