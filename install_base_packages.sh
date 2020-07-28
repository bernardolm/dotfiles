#!/bin/bash

source msg.sh

msg_init 'base packages'

sudo apt update

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
    diffuse \
    dkms \
    figlet \
    flashplugin-installer \
    fontconfig \
    fonts-powerline \
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
    gnome-panel \
    gnome-shell-extensions \
    gnome-tweak-tool \
    gnupg-agent \
    gparted \
    graphviz \
    gsettings-desktop-schemas \
    gthumb \
    htop \
    iotop \
    libkeybinder-3.0-0 \
    libmysqlclient-dev \
    libreoffice-calc \
    libutempter0 \
    libxml2-utils \
    make \
    mysql-client-5.7 \
    mysql-workbench \
    net-tools \
    nmap \
    nodejs \
    npm \
    ntfs-3g \
    ntfs-3g-dev \
    numix-gtk-theme \
    openssh-server \
    openvpn \
    pandoc \
    pm-utils \
    poedit \
    powertop \
    python-gtk2 \
    python-pip \
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
    ttf-ancient-fonts \
    tweak \
    ubuntu-restricted-extras \
    virtualenv \
    wget \
    xclip \
    zsh \
    && true

sudo apt purge --yes \
    fonts-noto-cjk \
    && true

msg_end 'base packages'
