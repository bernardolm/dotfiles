#!/bin/bash

source msg.sh

msg_init 'base packages install'

# sudo apt update

# baobab - Analisador de Uso de Disco - https://help.ubuntu.com/community/Baobab
# bleachbit - Clean Your System and Free Disk Space - https://www.bleachbit.org
# pandoc - a universal document converter - https://pandoc.org
# silversearcher-ag - The Silver Searcher - https://github.com/ggreer/the_silver_searcher

sudo apt install --yes --no-install-recommends \
    alacarte \
    apt-transport-https \
    aspell-fr \
    baobab \
    bleachbit \
    blueman \
    build-essential \
    ca-certificates \
    chrome-gnome-shell \
    colortest \
    conky \
    curl \
    dconf-cli \
    dconf-editor \
    dkms \
    figlet \
    flashplugin-installer \
    fontconfig \
    fritzing \
    gawk \
    gconf-editor \
    gdebi \
    gettext \
    gir1.2-keybinder-3.0 \
    gir1.2-notify-0.7 \
    gir1.2-vte-2.91 \
    gir1.2-wnck-3.0 \
    git \
    gnome-calendar \
    gnome-clocks \
    gnome-panel \
    gnome-shell-extensions \
    gnome-tweak-tool \
    gnome-weather \
    gnupg \
    gnupg-agent \
    google-chrome-stable \
    gparted \
    graphviz \
    gsettings-desktop-schemas \
    gsmartcontrol \
    gthumb \
    htop \
    iotop \
    kubectl \
    libkeybinder-3.0-0 \
    libmemcached-tools \
    libmysqlclient-dev \
    libreoffice-calc \
    libutempter0 \
    libxml2-utils \
    make \
    meld \
    mysql-client-5.7 \
    net-tools \
    nmap \
    nodejs \
    npm \
    openssh-server \
    openvpn \
    pandoc \
    pm-utils \
    powertop \
    python-gtk2 \
    python-pygments \
    python3 \
    python3-cairo \
    python3-dbus \
    python3-gi \
    python3-gpg \
    python3-pbr \
    python3-pip \
    samba \
    screen \
    silversearcher-ag \
    smartmontools \
    smem \
    software-properties-common \
    sublime-text \
    sudo \
    trash-cli \
    tweak \
    ubuntu-restricted-extras \
    virtualenv \
    vlc \
    wget \
    xclip \
    zsh

sudo apt install -f

msg_end 'base packages'
