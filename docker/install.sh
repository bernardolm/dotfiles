#!/usr/bin/env bash

source ../init/env.sh
source ../init/functions_loader.sh

_starting 'docker'

if [ ! $(command -v docker) ]; then
    sudo apt install --yes docker-ce docker-desktop docker-ce-cli containerd.io
    [ $(/bin/cat /etc/group | grep docker | wc -l | bc) -eq 0 ] && sudo groupadd docker && newgrp docker
    [ $(getent group docker | grep $USER | wc -l | bc) -eq 0 ] && sudo usermod -aG docker $USER
fi

_finishing 'docker'
