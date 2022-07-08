#!/bin/bash

source ./setup/env.sh
source ./setup/functions_loader.sh

msg_start 'setting apt'

[ -f ~/tmp/get_keys ] || touch -d "2 years ago" ~/tmp/get_keys

if test `find ~/tmp/get_keys -mmin +180`; then
    echo "fixing absent keys..."
    source $BASE_PATH/shell/get_keys.sh
    get_keys
    touch ~/tmp/get_keys
else
    echo "keys already fixed"
fi

[ -f ~/tmp/sudo_apt_update ] || touch -d "2 years ago" ~/tmp/sudo_apt_update

if test `find ~/tmp/sudo_apt_update -mmin +180`; then
    echo "apt updating..."
    sudo dpkg --add-architecture i386
    sudo apt-get update
    touch ~/tmp/sudo_apt_update
else
    echo "apt already updated"
fi

[ -f ~/tmp/sudo_apt_upgrade ] || touch -d "2 years ago" ~/tmp/sudo_apt_upgrade

if test `find ~/tmp/sudo_apt_upgrade -mmin +180`; then
    echo "apt upgrading..."
    sudo apt-get upgrade --yes
    touch ~/tmp/sudo_apt_upgrade
else
    echo "apt already upgraded"
fi

msg_end 'setting apt'
