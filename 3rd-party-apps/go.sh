#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'go'

if [ ! -f /usr/local/go/bin/go ]; then
    wget --quiet https://golang.org/dl/go1.16.14.linux-amd64.tar.gz -O ~/tmp/go.tar.gz
    sudo tar -vC /usr/local -xzf ~/tmp/go.tar.gz
    export PATH=$PATH:/usr/local/go/bin:
fi

msg_end 'go'
