FROM ubuntu:24.04


# Mise à jour du système
RUN apt-get update && apt-get upgrade -y

# Installer quelques outils
RUN apt-get install -y \
    sudo \
    bash \
    curl \
    git \
    locales \
    vim \
    python3 \
    python3-pip \
    python3-venv \
    lsb-release \
    wget \
    gnupg \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-libav \
    gstreamer1.0-gl \
    python3-gi \
    python3-gst-1.0 \
    libfuse2 \
    libxcb-xinerama0 \
    libxkbcommon-x11-0 \
    libxcb-cursor-dev



# Change root password
ARG ROOT_PASSWORD=root
RUN echo "root:${ROOT_PASSWORD}" | chpasswd

# Usename and password
ARG USERNAME=admin
ARG PASSWORD=admin
ARG UID=1000
ARG GID=1000
ENV USERNAME=${USERNAME}

# Del ubuntu user
RUN sudo userdel -r ubuntu

# Add user
RUN groupadd --gid ${GID} ${USERNAME} && \
    useradd --uid ${UID} \
            --gid ${GID} \
            -m \
            -s /bin/bash \
            ${USERNAME} && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd


# Création du groupe dialout
RUN GROUP=dialout; \
    if getent group "$GROUP" > /dev/null; then \
        echo "Le groupe $(getent group $GROUP) existe déjà"; \
    else \
        echo "Création du groupe $GROUP"; \
        groupadd "$GROUP"; \
    fi

# Ajouter les groupes a l'utilisateur
RUN usermod -aG sudo,dialout ${USERNAME} ; \
    id ${USERNAME}


RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Install codium
RUN wget -O /tmp/codium.deb \
    https://github.com/VSCodium/vscodium/releases/download/1.126.04524/codium_1.126.04524_amd64.deb && \
    apt-get update -y && \
    apt-get install -y /tmp/codium.deb && \
    rm /tmp/codium.deb


# Add USER environment variable
RUN echo 'export USER=$(id -un)' >> /etc/bash.bashrc


# ---------- Customize .bashrc and .bash_aliases ---------- #
RUN cat <<EOF > "/home/${USERNAME}/.bashrc"
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case \$- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "\$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "\${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=\$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "\$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "\$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "\$color_prompt" = yes ]; then
    PS1='(docker) \${debian_chroot:+(\$debian_chroot)}\[\033[01;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '
else
    PS1='(docker) \${debian_chroot:+(\$debian_chroot)}\u@\h:\w\\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "\$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\${debian_chroot:+(\$debian_chroot)}\u@\h: \w\a\]\$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
fi
EOF


RUN cat <<EOF > "/home/${USERNAME}/.bash_aliases"
alias lsa="ls -la"

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "\$(dircolors -b ~/.dircolors)" || eval "\$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
EOF


RUN cat <<'EOF' > /root/.bashrc
# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 is set in /etc/profile, and the default umask is defined
# in /etc/login.defs. You should not need this unless you want different
# defaults for root.
PS1='(docker) ${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# umask 022

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF

RUN cat <<'EOF' > /root/.bash_aliases
# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias lsa='ls -la'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
EOF

# ---------- END Customize .bashrc and .bash_aliases ---------- #

RUN echo "alias codium='codium --no-sandbox --ozone-platform=x11'" \
    >> /home/${USERNAME}/.bash_aliases

RUN chown "${USERNAME}:${USERNAME}" \
    "/home/${USERNAME}/.bash_aliases" \
    "/home/${USERNAME}/.bashrc"



# ---------- Install ROS2 ---------- #
RUN locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

RUN apt-get install -y \
    software-properties-common && \
    add-apt-repository universe && \
    apt-get update -y

RUN export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}') && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" && \
    dpkg -i /tmp/ros2-apt-source.deb

# Install dev Tools
RUN grep Suites /etc/apt/sources.list.d/ubuntu.sources

RUN apt-get update -y && \
    apt-get install -y \
    ros-dev-tools

# Install ROS2
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
    ros-jazzy-desktop

# Sourcing ROS2 to .bashrc
RUN cat <<EOF >> /home/${USERNAME}/.bashrc

# ROS2 sourcing
source /opt/ros/jazzy/setup.bash
EOF

# ---------- END Install ROS2 ---------- #


USER ${USERNAME}
WORKDIR /home/${USERNAME}

# ---------- Install QGroundControl ---------- #
RUN sudo usermod -aG dialout "$(id -un)" && \
    mkdir -p "/home/${USERNAME}/QGroundControl" && \
    wget -O "/home/${USERNAME}/QGroundControl/QGroundControl.AppImage" https://d176tv9ibo4jno.cloudfront.net/builds/master/QGroundControl-x86_64.AppImage && \
    chmod +x "/home/${USERNAME}/QGroundControl/QGroundControl.AppImage" && \
    cd "/home/${USERNAME}/QGroundControl" && \
    ./QGroundControl.AppImage --appimage-extract && \
    sudo ln -s "/home/${USERNAME}/QGroundControl/squashfs-root/AppRun" "/usr/bin/QGroundControl"


# ---------- END Install QGroundControl ---------- #


# ---------- Install PX4 and Gazebo ---------- #


# Import PX4 and Gazebo
RUN export USER=${USERNAME} && \
    cd "/home/${USERNAME}" && \
    git clone -b release/v1.17 https://github.com/ClubRobotiqueEsisar/PX4-GZ-TEMPLATE.git && \
    cd "PX4-GZ-TEMPLATE" && \
    ./install_px4_gz_ros2_for_ubuntu.sh

USER root

# px4 wrapper in /usr/bin
RUN cat > /usr/bin/px4 <<'EOF' && chmod +x /usr/bin/px4
#!/bin/bash
cd /home/wideroz/PX4-Autopilot/build/px4_sitl_default
exec ./bin/px4 "$@"
EOF

USER ${USERNAME}

# ---------- END Install PX4 and Gazebo ---------- #

# Clean Image
RUN sudo apt-get update && \
    sudo rm -rf /var/lib/apt/lists/*



# Entrypoint
COPY scripts/entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


# Déclarer un point de montage pour le volume
VOLUME ["/data"]


# Commande par défaut
CMD ["/bin/bash"]