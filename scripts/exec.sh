sudo docker exec -it \
    ros-gazebo-container \
    bash -c "echo \"Write the password of the container's user\" && exec su -p $USER"