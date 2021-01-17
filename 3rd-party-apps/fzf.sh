#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'fzf'

if [[ "$(command -v fzf)" == "" ]]; then
    if [ ! -d "~/.fzf" ]; then
        echo "cloning fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi
    ~/.fzf/install
fi

msg_end 'fzf'
