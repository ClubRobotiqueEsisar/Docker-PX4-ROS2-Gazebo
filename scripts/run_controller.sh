#!/bin/bash

sudo docker run -it \
    --name ros-gazebo-container \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --device=/dev/input \
    -v "$(pwd)/data":/data \
    ros-gazebo