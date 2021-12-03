#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'dbeaver'

if [[ "$(command -v dbeaver)" == "" ]]; then
    curl https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -o ~/tmp/dbeaver.deb && sudo dpkg -i ~/tmp/dbeaver.deb
fi

msg_end 'dbeaver'
