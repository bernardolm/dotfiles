#!/bin/bash

source msg.sh

msg_init 'base packages install'

# sudo apt update

# Baobab - Analisador de Uso de Disco
# BleachBit - Clean Your System and Free Disk Space
# Pandoc - a universal document converter

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
    gnome-calendar \
    gettext \
    gir1.2-keybinder-3.0 \
    gir1.2-notify-0.7 \
    gir1.2-vte-2.91 \
    gir1.2-wnck-3.0 \
    git \
    gnome-panel \
    gnome-shell-extensions \
    gnome-tweak-tool \
    gnupg \
    gnupg-agent \
    gparted \
    graphviz \
    gsettings-desktop-schemas \
    gthumb \
    htop \
    iotop \
    kubectl \
    libkeybinder-3.0-0 \
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
    smem \
    software-properties-common \
    sudo \
    trash-cli \
    tweak \
    ubuntu-restricted-extras \
    virtualenv \
    wget \
    xclip \
    zsh \
    && true

sudo apt install -f

msg_end 'base packages'
