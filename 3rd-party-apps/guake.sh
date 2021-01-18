#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'guake'

if [[ "$(command -v guake)" == "" ]]; then
    pip install --user guake
fi

msg_end 'guake'
