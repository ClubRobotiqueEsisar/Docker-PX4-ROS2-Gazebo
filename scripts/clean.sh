#!/bin/bash

# Clear the reclaimable build cache
sudo docker builder prune -a

# Clear the reclaimable image
sudo docker image prune -a
