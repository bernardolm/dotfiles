#!/usr/bin/zsh
source ~/.zshrc

function cron/dropbox() {
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

log_path="$USER_TMP/var/log/cron/dropbox"
# log_path="$HOME/tmp/var/log/cron/dropbox"

if [ ! -d "$log_path" ]; then
    echo -e "creating dropbox log folder '$log_path'..."
    mkdir -p "$log_path"
fi

cron/dropbox > $log_path/$(date +"%Y-%m-%d-%H-%M").log 2>&1
