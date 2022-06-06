#!/bin/bash

export BASE_PATH=$WORKSPACE_USER/dotfiles
source $BASE_PATH/msg.sh

msg_init 'guake'

# NOTE: Installing by apt

# if [[ "$(command -v guake)" == "" ]]; then
#     git clone https://github.com/Guake/guake.git ~/.guake
#     cd ~/.guake
#     ./scripts/bootstrap-dev-debian.sh run make
#     make
#     sudo make install
# fi

msg_end 'guake'
