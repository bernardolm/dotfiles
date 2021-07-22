function backup_snap_packages() {
    mv $SYNC_PATH/snap-packages/$(hostname)_current.txt $SYNC_PATH/snap-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    snap list > $SYNC_PATH/snap-packages/$(hostname)_current.txt
}
