#!/bin/bash

source msg.sh

msg_init 'snap packages'

sudo snap refresh

sudo snap install \
    dbeaver-ce \
    glimpse-editor \
    gtk-common-themes \
    gtk2-common-themes \
    postman \
    redis-desktop-manager \
    snap-store \
    spotify \
    sweethome3d-homedesign \
    && true

msg_end 'snap packages'
