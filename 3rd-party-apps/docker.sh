#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'docker'

if [[ "$(command -v docker)" == "" ]]; then
    sudo apt install --yes docker-ce docker-ce-cli containerd.io
    [ `cat /etc/group | grep docker | wc -l | bc` -eq 0 ] && sudo groupadd docker
    sudo usermod -aG docker $USER
    ## newgrp docker # FIXME: exiting from current shell
fi

msg_end 'docker'
