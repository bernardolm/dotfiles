#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'oh-my-zsh'

if [[ ! -d "~/.oh-my-zsh" ]]; then
    sh -c "CHSH=no KEEP_ZSHRC=yes $(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

msg_end 'oh-my-zsh'
