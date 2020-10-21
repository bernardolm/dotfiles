#!/bin/bash

function dropbox_schedule() {
    echo -e "running dropbox..."
    dropbox start >/dev/null
    echo -e "giving 5m to dropbox work..."
    sleep 5m
    echo -e "stopping dropbox..."
    dropbox stop
}

log_path="$USER_TMP/var/log/dropbox_schedule"

if [ ! -d "$log_path" ]; then
    echo -e "creating dropbox log folder '$log_path'..."
    mkdir -p "$log_path"
fi

dropbox_schedule | tee $log_path/$(date +"%Y-%m-%d-%H-%M").log
