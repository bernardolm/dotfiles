#!/bin/bash

function dropbox_schedule() {
    echo -e "running dropbox..."
    dropbox start >/dev/null
    echo -e "giving 5m to dropbox work..."
    sleep 5m
    echo -e "stopping dropbox..."
    dropbox stop
}

dropbox_schedule_log_dir="$HOME/var/log/dropbox_schedule"

if [ ! -d "$dropbox_schedule_log_dir" ]; then
    echo -e "creating dropbox log folder '$dropbox_schedule_log_dir'..."
    mkdir -p "$dropbox_schedule_log_dir"
fi

dropbox_schedule | tee $dropbox_schedule_log_dir/$(date +"%Y-%m-%d-%H-%M").log
