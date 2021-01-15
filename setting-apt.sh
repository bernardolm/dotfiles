#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'setting apt'

source $BASE_PATH/shell-scripts/get_keys.sh

get_keys

sudo dpkg --add-architecture i386

sudo apt update

msg_end 'setting apt'
