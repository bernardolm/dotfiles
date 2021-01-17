#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'remote folder'

function install_dropbox() {
    function is_dropbox_finish() {
        check1=`dropbox status | grep -c -i "up to date" | bc`
        check2=`dropbox status | grep -c -i "atualizado" | bc`
        result=`expr $check1 + $check2`
        [ $result -gt 0 ] && true
    }

    if [[ "$(command -v dropbox)" == "" ]]; then
        echo -e "\ninstalling dropbox..."
        sudo apt install --yes python3-gpg curl
        nautilus --quit
        curl https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb -o ~/tmp/dropbox.deb && sudo dpkg -i ~/tmp/dropbox.deb
    fi

    dropbox start &> /dev/null

    while : ; do
        is_dropbox_finish && break
        dropbox status
        sleep 5s
    done

    [ ! -h ~/Sync ] && ln -s ~/Dropbox ~/Sync
}

install_dropbox

msg_end 'remote folder'
