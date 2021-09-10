function backup_apt_packages() {
    mkdir -p $SYNC_PATH/apt-packages/
    mv $SYNC_PATH/apt-packages/$(hostname)_current.txt $SYNC_PATH/apt-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    dpkg --get-selections > $SYNC_PATH/apt-packages/$(hostname)_current.txt
}
