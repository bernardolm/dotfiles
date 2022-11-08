#!/usr/bin/env zsh

source $DOTFILES/setup/env.sh
source $DOTFILES/zsh/google_drive_sync.zsh

log_path=$USER_TMP/cron/google-drive-worker

if [ ! -d $log_path ]; then
    echo -e "creating google drive worker log folder '$log_path'..."
    mkdir -p $log_path
fi

google_drive_sync > $log_path/$(date +"%Y%m%d%H%M%S").log 2>&1
