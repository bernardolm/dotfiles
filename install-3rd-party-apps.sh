#!/bin/bash

source $BASE_PATH/msg.sh

msg_init '3rd party apps'

export PATH=$PATH:$HOME/.local/bin:

for NAME in $(find $(dirname $(readlink -f $0))/3rd-party-apps/*.sh); do
    source $NAME
done

msg_end '3rd party apps'
