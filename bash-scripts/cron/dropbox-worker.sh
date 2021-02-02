#!/bin/bash

function dropbox_worker() {
    wait_for=5m

    echo -e "running dropbox-worker..."
    notify-send "dropbox-worker" "running..."

    dropbox start

    echo -e "giving $wait_for to dropbox work..."
    sleep $wait_for

    dropbox stop

    echo -e "finish dropbox-worker"
    notify-send "dropbox-worker" "finish"
}

log_path=~/tmp/cron/dropbox-worker

if [ ! -d $log_path ]; then
    echo -e "creating dropbox-worker log folder '$log_path'..."
    mkdir -p $log_path
fi

dropbox_worker > $log_path/$(date +"%Y-%m-%d-%H-%M").log 2>&1
