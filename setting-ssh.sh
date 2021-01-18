#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'setting ssh'

ssh-keygen -t ed25519 -C "`git config user.email`"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

msg_end 'setting ssh'
