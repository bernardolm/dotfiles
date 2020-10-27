#!/bin/bash

function dropbox_schedule() {
    echo -e "running dropbox crontab..." && notify-send "dropbox crontab" "running..."
    dropbox start >/dev/null
    echo -e "giving 5m to dropbox work..."
    sleep 5m
    dropbox stop
    echo -e "finish dropbox crontab" && notify-send "dropbox crontab" "finish"
}

log_path="$USER_TMP/var/log/dropbox_schedule"

if [ ! -d "$log_path" ]; then
    echo -e "creating dropbox log folder '$log_path'..."
    mkdir -p "$log_path"
fi

dropbox_schedule | tee $log_path/$(date +"%Y-%m-%d-%H-%M").log
