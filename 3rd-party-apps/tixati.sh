#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'tixati'

if [[ "$(command -v tixati)" == "" ]]; then
    curl https://download2.tixati.com/download/tixati_2.75-1_amd64.deb -o ~/tmp/tixati.deb && sudo dpkg -i ~/tmp/tixati.deb
fi

msg_end 'tixati'
