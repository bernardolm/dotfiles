#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'guake'

if [[ "$(command -v guake)" == "" ]]; then
    # pip3 install --user guake
    # export PATH=$PATH:$HOME/.local/bin:
    # /usr/local/bin/guake

    git clone https://github.com/Guake/guake.git ~/.guake
    cd ~/.guake
    ./scripts/bootstrap-dev-debian.sh run make
    make
    sudo make install
fi

msg_end 'guake'
