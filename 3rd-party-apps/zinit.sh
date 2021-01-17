#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'zinit'

if [[ "$(command -v zinit)" == "off" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi

msg_end 'zinit'
