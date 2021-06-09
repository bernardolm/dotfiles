function google_drive_sync() {
    echo -e "running google drive worker..."
    notify-send "google drive worker" "running..."

    echo -e "syncing local..."
    rsync -avu --delete $SYNC_PATH/ $HOME/google-drive/config-backup/

    echo -e "syncing virtual..."
    drive push -ignore-name-clashes -ignore-conflict $HOME/google-drive

    echo -e "finish google drive worker"
    notify-send "google drive worker" "finish"
}
