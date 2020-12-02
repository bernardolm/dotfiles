#!/usr/bin/env /usr/bin/zsh

function dropbox_schedule() {
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

log_path="$USER_TMP/var/log/dropbox_schedule"

if [ ! -d "$log_path" ]; then
    echo -e "creating dropbox log folder '$log_path'..."
    mkdir -p "$log_path"
fi

dropbox_schedule > $log_path/$(date +"%Y-%m-%d-%H-%M").log 2>&1
