#!/bin/zsh

source ../init/env.sh
source ../init/functions_loader.sh

msg_start '3rd party apps'

for NAME in $(find $(dirname $(readlink -f $0))/3rd-party-apps/*.sh); do
    source $NAME
done

msg_end '3rd party apps'
