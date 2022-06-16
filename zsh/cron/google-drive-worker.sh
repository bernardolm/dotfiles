#!/bin/zsh

source $DOTFILES/shell/init/env.sh
source $DOTFILES/shell/google_drive_sync.sh

log_path=$USER_TMP/cron/google-drive-worker

if [ ! -d $log_path ]; then
    echo -e "creating google drive worker log folder '$log_path'..."
    mkdir -p $log_path
fi

google_drive_sync > $log_path/$(date +"%Y%m%d%H%M%S").log 2>&1