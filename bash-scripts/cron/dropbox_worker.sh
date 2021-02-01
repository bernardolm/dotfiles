#!/bin/bash

function dropbox_worker() {
    wait_for=5m

    echo -e "running dropbox crontab..."
    notify-send "dropbox crontab" "running..."

    dropbox start

    echo -e "giving $wait_for to dropbox work..."
    sleep $wait_for

    dropbox stop

    echo -e "finish dropbox crontab"
    notify-send "dropbox crontab" "finish"
}

log_path="~/tmp/cron/dropbox"

if [ ! -d "$log_path" ]; then
    echo -e "creating dropbox log folder '$log_path'..."
    mkdir -p "$log_path"
fi

dropbox_worker > $log_path/$(date +"%Y-%m-%d-%H-%M").log 2>&1
