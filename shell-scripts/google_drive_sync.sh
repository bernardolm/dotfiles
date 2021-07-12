function google_drive_sync() {
    echo -e "running google drive worker..."
    notify-send "google drive worker" "running..."

    echo -e "syncing local..."
    rsync -au --delete $SYNC_PATH/ $HOME/google-drive/config-backup/

    echo -e "removing vendor paths..."
    find $HOME/google-drive/config-backup/ -name 'node_modules' -exec /bin/rm rm -rf {} \; 2>/dev/null

    echo -e "syncing virtual..."
    cd $HOME/google-drive && \
        drive pull -ignore-name-clashes -ignore-conflict config-backup && \
        drive push -ignore-name-clashes -ignore-conflict config-backup

    echo -e "finish google drive worker"
    notify-send "google drive worker" "finish"
}
