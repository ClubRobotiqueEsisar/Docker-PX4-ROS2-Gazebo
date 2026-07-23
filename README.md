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
![[Pasted image 20260722230734.png]]
```bash
./docker_commands.sh
```
Available selections : 
- build : Build the Dockerfile to get the image.
- run : Run the image created by the build
- exec : Open a new session for the user
- clean : Clean the reclaimable build and image (to see the reclaimable space type : `sudo docker system df`)
- start : Starts the docker's container
- stop : Stops the docker's container

Those selections are running a script defined bellow PLEASE READ THE WARNINGS.
### 1.3 - Docker scripts
#### a. Build the Dockerfile
```bash
script/build.sh
```

#### b. Start a container from the image
```bash
script/run.sh
```

#### c. Clean your build cache and images that are unused by any container (optional)
This step will remove 40 GB max. 
```bash
script/clean.sh
```

> [!WARNING]
> This action will remove all the build cache and all unused images (images that are not assigned to a container)

#### d. Build with logs
```bash
script/build_log.sh
```
Get the full logs during the build in the file : log/build.log

#### e. Run with a controller
```bash
script/run_controller.sh
```
See the $3^{rd}$ section to have more information

#### f. Open a new session
```bash
script/exec.sh
```
Open another bash session in the container

#### g. Start the container
```bash
script/start_container.sh
```
Start the container

#### h. Stop the container
```bash
script/stop_container.sh
```
Stop the container

## 3. Setup a controller
In the docker container, please check the group of the files in the directory : 
```bash
ls -l /dev/input
```
If the group of all files is, for example : `input`, you must add this group to the user in the container : 
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
This command is an alias of `codium --no-sandbox --ozone-platform=x11` defined in this file : `/home/$USER/.bash_aliases`


```Dockerfile
sudo apt update && sudo apt install -y \
mesa-utils \
libglvnd0 \
libgl1 \
libglx0 \
libegl1

glxinfo -B
```
