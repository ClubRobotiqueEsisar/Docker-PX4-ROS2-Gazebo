#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LOG_PATH="$SCRIPT_DIR/../log"
LOG_FILE="$LOG_PATH/QGroundControl.log"

mkdir -p "$LOG_PATH"

sudo docker exec \
    ros-gazebo-container \
    QGroundControl \
    > "$LOG_FILE" 2>&1 &