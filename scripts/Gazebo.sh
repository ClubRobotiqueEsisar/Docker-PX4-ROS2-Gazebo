#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
LOG_PATH="$SCRIPT_DIR/../log"
LOG_FILE="$LOG_PATH/Gazebo.log"

mkdir -p "$LOG_PATH"

sudo docker exec -it ros-gazebo-container bash -c '
export PX4_SYS_AUTOSTART=4010
export PX4_SIM_MODEL=gz_x500_mono_cam_down
export PX4_GZ_MODEL_POSE="-1,0,0.1,0,0,3.14159265359"
export PX4_GZ_WORLD=test_world

exec px4
' 2>&1 | tee >(grep -v "^pxh>" > "$LOG_FILE")