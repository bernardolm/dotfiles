#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'zinit'

if [ ! -f $HOME/.zinit/bin/zinit.zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
    export PATH=$PATH:$HOME/.zinit/bin:
fi

msg_end 'zinit'
