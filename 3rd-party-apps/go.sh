#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'go'

if [[ "$(command -v go)" == "" ]]; then
    wget --quiet https://golang.org/dl/go1.15.2.linux-amd64.tar.gz -O ~/tmp/go.tar.gz
    sudo /bin/rm -rf $GOPATH/pkg
    sudo tar -C /usr/local -xzf ~/tmp/go.tar.gz
fi

msg_end 'go'
