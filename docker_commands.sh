#!/bin/bash
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# ---------- Check if fzf is installed if not, install it ---------- #

if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf n'est pas installé. Installation..."

    if command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y fzf

    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y fzf

    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y fzf

    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm fzf

    elif command -v brew >/dev/null 2>&1; then
        brew install fzf

    else
        echo "Gestionnaire de paquets non pris en charge."
        exit 1
    fi
fi

# ---------- END Check if fzf is installed if not, install it ---------- #


commands=$(echo -e "Run QGroundControl and Gazebo\nRemove Container\nStop\nStart\nClean\nExec\nRun\nBuild" | fzf)

# Esc or Ctrl-C
[ -z "$commands" ] && exit 0

case "$commands" in
    Build)
        echo "Building"
        read -rp "Build with logs ? (y/N) : " answer

        case "$answer" in
            [Yy]|[Yy][Ee][Ss])
                echo "Building with logs"
                bash "$SCRIPT_DIR/scripts/build_log.sh"
                ;;
            *)
                echo "Building without logs"
                bash "$SCRIPT_DIR/scripts/build.sh"
                ;;
        esac
        ;;
    Run)
        echo "Running"
        read -rp "Run with a joystick controller ? (y/N) : " answer

        case "$answer" in
            [Yy]|[Yy][Ee][Ss])
                echo "Running with a controller"
                bash "$SCRIPT_DIR/scripts/run_controller.sh"
                ;;
            *)
                echo "Running without a controller"
                bash "$SCRIPT_DIR/scripts/run.sh"
                ;;
        esac
        ;;
    Exec)
        echo "Executing"
        bash "$SCRIPT_DIR/scripts/exec.sh"
        ;;
    Clean)
        echo "Cleaning"
        bash "$SCRIPT_DIR/scripts/clean.sh"
        ;;
    Start)
        echo "Starting Container"
        bash "$SCRIPT_DIR/scripts/start_container.sh"
        ;;
    Stop)
        echo "Stoping Container"
        bash "$SCRIPT_DIR/scripts/stop_container.sh"
        ;;

    "Remove Container")
        echo "Removing Container"
        bash "$SCRIPT_DIR/scripts/rm_container.sh"
        ;;

    "Run QGroundControl and Gazebo")
        echo "Running QGroundControl and Gazebo..."
        bash "$SCRIPT_DIR/scripts/QGroundControl.sh"
        bash "$SCRIPT_DIR/scripts/Gazebo.sh"
        ;;
    *)
        echo "Unknown command : $command"
        exit 1
        ;;
esac