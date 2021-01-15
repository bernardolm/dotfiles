#!/usr/bin/zsh
source ~/.zshrc

timestamp=$(date +"%Y-%m-%d-%H-%M")

while read line; do
    paths=("${(@s/;/)line}")
    from=${paths[1]}
    to=${paths[2]}

    if [ ! -L $to ] ; then
        mv $to "$to-bkp-$timestamp"

        if [[ "$to" == "/home"* ]]; then
            ln -s $from $to
        else
            sudo ln -s $from $to
        fi
    else
        echo "$to already is a sym link"
    fi
done <$SYNC_PATH/scripts/my-sym-links.txt
