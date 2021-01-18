#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'setting ssh'

if [ `ls -al ~/.ssh | grep -c id_ | bc` == 0 ]; then
    ssh-keygen -t ed25519 -C "`git config user.email`"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
else
    echo "keys founded"
fi

msg_end 'setting ssh'
