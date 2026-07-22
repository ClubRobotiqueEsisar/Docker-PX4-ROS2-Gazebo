#!/bin/bash
set -e

if [ -n "$USERNAME" ] && id "$USERNAME" >/dev/null 2>&1; then
    echo "Connection with the docker's user : $USERNAME"
    exec su -p "$USERNAME"
else
    echo "User $USERNAME inexistant, default launch"
    exec "$@"
fi