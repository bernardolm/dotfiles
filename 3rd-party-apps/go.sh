#!/bin/bash

source ./shell/init/env.sh
source ./shell/init/functions_loader.sh

msg_start 'go'

if [ ! -f /usr/local/go/bin/go ]; then
    wget --quiet https://golang.org/dl/go1.16.15.linux-amd64.tar.gz -O ~/tmp/go.tar.gz
    sudo /bin/rm -rf /usr/local/go
    sudo tar -vC /usr/local -xzf ~/tmp/go.tar.gz
fi

msg_end 'go'
