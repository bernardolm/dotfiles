#!/bin/bash

export BASE_PATH=$WORKSPACE_USER/dotfiles
source $BASE_PATH/msg.sh

msg_init 'base packages'

# NOTE: Restoring by last installed backup

# [ -f ~/tmp/apt_base_packages ] || touch -d "2 years ago" ~/tmp/apt_base_packages

# if test `find ~/tmp/apt_base_packages -mmin +180`; then
#     sudo apt-get install --yes --no-install-recommends \
#         alacarte \
#         apt-transport-https \
#         aspell-fr \
#         baobab \
#         bleachbit \
#         blueman \
#         build-essential \
#         ca-certificates \
#         chrome-gnome-shell \
#         clamav \
#         clamav-base \
#         clamav-daemon \
#         clamav-freshclam \
#         colortest \
#         conky \
#         curl \
#         dconf-cli \
#         dconf-editor \
#         dkms \
#         figlet \
#         flashplugin-installer \
#         fontconfig \
#         fonts-symbola \
#         fritzing \
#         gawk \
#         gconf-editor \
#         gdebi \
#         gettext \
#         gir1.2-keybinder-3.0 \
#         gir1.2-notify-0.7 \
#         gir1.2-vte-2.91 \
#         gir1.2-wnck-3.0 \
#         git \
#         gnome-calendar \
#         gnome-clocks \
#         gnome-panel \
#         gnome-shell-extensions \
#         gnome-tweak-tool \
#         gnome-tweaks \
#         gnupg \
#         gnupg-agent \
#         gparted \
#         graphviz \
#         gsettings-desktop-schemas \
#         gsmartcontrol \
#         gstreamer1.0-plugins-bad \
#         gstreamer1.0-plugins-ugly \
#         gthumb \
#         htop \
#         iotop \
#         jq \
#         libfdk-aac1 \
#         libgconf2-dev \
#         libkeybinder-3.0-0 \
#         libmemcached-tools \
#         libmysqlclient-dev \
#         libutempter0 \
#         libvulkan-dev \
#         libvulkan1 \
#         libxml2-utils \
#         make \
#         mariadb-client-10.3 \
#         meld \
#         net-tools \
#         nodejs \
#         npm \
#         openssh-server \
#         openvpn \
#         pandoc \
#         pm-utils \
#         powertop \
#         python-pygments \
#         python3 \
#         python3-all-dev \
#         python3-cairo \
#         python3-dbus \
#         python3-dev \
#         python3-gi \
#         python3-gpg \
#         python3-pbr \
#         python3-pip \
#         qml-module-qt-labs-platform \
#         qml-module-qtquick-controls \
#         qml-module-qtquick-dialogs \
#         qml-module-qtwebchannel \
#         qml-module-qtwebengine \
#         resolvconf \
#         samba \
#         screen \
#         shellcheck \
#         silversearcher-ag \
#         smartmontools \
#         smem \
#         snap \
#         snapd \
#         software-properties-common \
#         sudo \
#         traceroute \
#         trash-cli \
#         ttf-ancient-fonts-symbola \
#         tweak \
#         ubuntu-restricted-extras \
#         virtualenv \
#         vlc \
#         vulkan-utils \
#         wget \
#         winetricks \
#         xclip \
#         xsane \
#         zsh

#     sudo apt-get install -f --yes

#     touch ~/tmp/apt_base_packages
# else
#     echo "base packages updated"
# fi

msg_end 'base packages'
