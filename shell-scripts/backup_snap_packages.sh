function backup_snap_packages() {
    snap list >$SYNC_PATH/snap_packages_$(hostname)
}
