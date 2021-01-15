#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'restore symbolic links'

timestamp=$(date +"%Y-%m-%d-%H-%M")

while read line; do
    # only to ZSH
    # paths=("${(@s/;/)line}")
    # from=${paths[1]}
    # to=${paths[2]}

    IFS=';' read -r -a paths <<< "$line"
    from=${paths[0]}
    to=${paths[1]}

    echo "from $from to $to"

    if [ ! -n $to ] ; then
        if [[ "$to" == "/home"* ]]; then
            mv $to "$to-bkp-$timestamp"
            ln -sf $from $to
        else
            sudo mv $to "$to-bkp-$timestamp"
            sudo ln -sf $from $to
        fi
    else
        echo "$to already is a sym link"
    fi
done <~/Sync/config-backup/scripts/my-sym-links.txt

msg_end 'restore symbolic links'
