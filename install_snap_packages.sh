#!/bin/bash

source msg.sh

msg_init 'snap packages'

sudo snap update

sudo snap install \
    canonical-livepatch \
    core \
    core18 \
    dbeaver-ce \
    glimpse-editor \
    gnome-3-26-1604 \
    gnome-3-28-1804 \
    gnome-3-34-1804 \
    gnome-calculator \
    gnome-characters \
    gnome-system-monitor \
    gtk-common-themes \
    gtk2-common-themes \
    nimblenote \
    postman \
    qt551 \
    redis-desktop-manager \
    snap-store \
    snapd \
    spotify \
    sweethome3d-homedesign \
    && true

msg_end 'snap packages'
