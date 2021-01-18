#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'guake'

if [[ "$(command -v guake)" == "" ]]; then
    pip3 install --user guake
    export PATH=$PATH:~/.local/bin
fi

msg_end 'guake'
