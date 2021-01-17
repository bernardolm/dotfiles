#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'bleachbit'

if [[ "$(command -v bleachbit)" == "" ]]; then
    curl https://download.bleachbit.org/bleachbit_4.0.0_all_ubuntu1904.deb -o ~/tmp/bleachbit.deb && sudo dpkg -i ~/tmp/bleachbit.deb
fi

msg_end 'bleachbit'
