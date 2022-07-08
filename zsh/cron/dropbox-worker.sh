#!/bin/zsh

source $DOTFILES/setup/env.sh
source $DOTFILES/shell/dropbox_sync.sh

log_path=$USER_TMP/cron/dropbox-worker

if [ ! -d $log_path ]; then
    echo -e "creating dropbox-worker log folder '$log_path'..."
    mkdir -p $log_path
fi

dropbox_sync > $log_path/$(date +"%Y%m%d%H%M%S").log 2>&1
