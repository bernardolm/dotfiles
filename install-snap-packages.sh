#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'snap packages'

[ -f ~/tmp/snap_packages ] || touch -d "2 years ago" ~/tmp/snap_packages

if test `find ~/tmp/snap_packages -mmin +180`; then
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
else
    echo "snap packages updated"
fi

msg_end 'snap packages'
