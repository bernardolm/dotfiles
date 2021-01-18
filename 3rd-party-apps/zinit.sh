#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'zinit'

if [[ ! -d $HOME/.zinit ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
    export PATH=$PATH:/home/bernardo/.zinit/bin
fi

msg_end 'zinit'
