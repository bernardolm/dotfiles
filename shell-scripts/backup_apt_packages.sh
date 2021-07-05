function backup_apt_packages() {
    dpkg --get-selections >$SYNC_PATH/apt_packages_$(hostname)
}
