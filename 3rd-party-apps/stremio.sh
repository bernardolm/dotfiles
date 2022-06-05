#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'stremio'

# if [[ "$(command -v stremio)" == "" ]]; then
#     curl https://dl.strem.io/shell-linux/v4.4.116/stremio_4.4.116-1_amd64.deb -o ~/tmp/stremio.deb && sudo dpkg -i ~/tmp/stremio.deb
# fi

msg_end 'stremio'
