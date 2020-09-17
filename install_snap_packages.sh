#!/bin/bash

source msg.sh

msg_init 'snap packages install'

sudo snap refresh

sudo snap install \
    dbeaver-ce \
    glimpse-editor \
    postman \
    redis-desktop-manager \
    spotify \
    sweethome3d-homedesign \
    && true

sudo snap install \
    code \
    --classic \
    && true

msg_end 'snap packages'
