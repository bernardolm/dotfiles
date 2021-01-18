#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'guake'

if [[ "$(command -v guake)" == "" ]]; then
    # curl -L -o ~/tmp/guake.zip https://github.com/Guake/guake/archive/master.zip
    git clone https://github.com/Guake/guake.git ~/tmp/guake
    # unzip -oq ~/tmp/guake.zip -d ~/tmp/guake
    cd ~/tmp/guake/guake-master
    ./scripts/bootstrap-dev-debian.sh run make
    make
    sudo make install
    cd -
fi

msg_end 'guake'
