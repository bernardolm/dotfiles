#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'guake'

if [[ "$(command -v guake)" == "" ]]; then
    pip install --user guake
    export PATH=$PATH:/usr/local/bin
fi

msg_end 'guake'
