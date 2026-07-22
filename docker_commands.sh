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


commands=$(echo -e "stop\nstart\nclean\nexec\nrun\nbuild" | fzf)

# Esc or Ctrl-C
[ -z "$commands" ] && exit 0

case "$commands" in
    build)
        echo "Build"
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
    run)
        echo "Run"
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
    exec)
        echo "Exec"
        bash "$SCRIPT_DIR/scripts/exec.sh"
        ;;
    clean)
        echo "Clean"
        bash "$SCRIPT_DIR/scripts/clean.sh"
        ;;
    start)
        echo "Start"
        bash "$SCRIPT_DIR/scripts/start_container.sh"
        ;;
    stop)
        echo "Stop"
        bash "$SCRIPT_DIR/scripts/stop_container.sh"
        ;;
    *)
        echo "Unknown command : $command"
        exit 1
        ;;
esac