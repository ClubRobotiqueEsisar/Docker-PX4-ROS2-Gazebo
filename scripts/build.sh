#!/bin/bash
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

read -s -p "Write the password of your container : " PASSWORD
echo

sudo docker build \
    --label project=ros-gazebo \
    --build-arg USERNAME=$(id -un) \
    --build-arg PASSWORD="$PASSWORD" \
    --build-arg GID=$(id -g) \
    --build-arg UID=$(id -u) \
    -t ros-gazebo "$SCRIPT_DIR/.."