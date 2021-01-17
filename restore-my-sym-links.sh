#!/bin/bash

source $BASE_PATH/msg.sh

msg_init 'restore symbolic links'

timestamp=$(date +"%Y-%m-%d-%H-%M")

while read line; do
    function ln_smart() {
        from=$0
        to=$1

        if [[ "$to" == "/home"* ]]; then
            mv $to "$to-bkp-$timestamp"
            ln -sf $from $to
        else
            sudo mv $to "$to-bkp-$timestamp"
            sudo ln -sf $from $to
        fi
    }

    # only to ZSH
    # paths=("${(@s/;/)line}")
    # from=${paths[1]}
    # to=${paths[2]}

    IFS=';' read -r -a paths <<< "$line"
    from=${paths[0]}
    to=${paths[1]}

    echo "from $from to $to"

    if test -d $to; then
        if test -L $to; then
            echo "$to is a symlink to a directory"
        else
            echo "$to is just a plain directory"
            ln_smart $from $to
        fi
    else
        if test -L $to; then
            echo "$to is a symlink to a file"
        else
            echo "$to is just a plain file"
            ln_smart $from $to
        fi
    fi
done <~/Sync/config-backup/scripts/my-sym-links.txt

msg_end 'restore symbolic links'
