# Description
This repository contains a Dockerfile and some scripts to interact with it in order to get ROS2 jazzy and Gazebo, QGroundControl with a graphical interface.

# Requirements
- Size of ~60 GB at the end of the build and a bit more than 20 GB after the clean
- Docker
- X11/XWayland

Verify on which graphical session you are : 
```bash
echo $XDG_SESSION_TYPE
```
If it returns `X11` you reached the requirements,
If it returns : `wayland` you need to verify that `XWayland` is running :
```bash
ps -e | grep Xwayland
```
If it is not install XWayland

# I - Installation and scripts
## 1.
### 1.1 - Add the user to the xhost server
```bash
xhost +SI:localuser:$(id -un)
```

> [!WARNING]
> Do not execute this command in root


### 1.2 - Docker commands
Simple interface to launch docker commands

### 1.3 - Docker scripts
#### a. Build the Dockerfile
```bash
./build.sh
```
You can get the build logs in the following file : log/build.log

#### b. Start a container from the image
```bash
./run.sh
```

#### c. Clean your build cache and images that are unused by any container (optional)
This step will remove approximately 40 GB 
```bash
./clean.sh
```

> [!WARNING]
> This action will remove all the build cache and all unused images (images that are not assigned to a container)

#### d. build_log.sh
Get the full logs during the build in the file : log/build.log

#### e. exec.sh
Open another bash session in the container

#### f. start_container.sh
Start the container

#### g. stop_container.sh
Stop the container

## 3. Setup a joystick controller
In the docker container, please check the group of the files in the directory : 
```bash
ls -l /dev/input
```
If the group is for example : `input`, you must add this group to the user : 
```bash
sudo usermod -aG input "$USER"
```

# II - Container apps
#### QGroundControl
You can launch QGroundControl with the `QGroundControl` command in the container

#### Gazebo
You can launch Gazebo by launching the following command : 
```bash
PX4_SYS_AUTOSTART=4010 \
PX4_SIM_MODEL=gz_x500_mono_cam_down \
PX4_GZ_MODEL_POSE="-1,0,0.1,0,0,3.14159265359" \
PX4_GZ_WORLD=test_world \
~/PX4-Autopilot/build/px4_sitl_default/bin/px4
```

#### VS Codium
Type the following command in the terminal to code in the container
```bash
codium .
```
