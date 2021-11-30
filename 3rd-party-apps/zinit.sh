#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'zinit'

if [ ! -f $HOME/.zinit/bin/zinit.zsh ]; then
    sh -c "$(curl -fsSL https://git.io/zinit-install)"
    export PATH=$PATH:$HOME/.zinit/bin:
fi

msg_end 'zinit'
