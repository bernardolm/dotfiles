function backup_snap_packages() {
    mkdir -p $SYNC_PATH/snap-packages/
    [ -f $SYNC_PATH/snap-packages/$(hostname)_current.txt ] && mv \
        $SYNC_PATH/snap-packages/$(hostname)_current.txt $SYNC_PATH/snap-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    snap list | /bin/grep -v Publisher > $SYNC_PATH/snap-packages/$(hostname)_current.txt
}

function restore_snap_packages() {
    local file=$(last_backup_version snap-packages txt)

    sudo snap refresh

    echo "installing classic snap packages..."
    /bin/cat $file | /bin/grep classic | /bin/awk -F' ' '{print $1}' | \
        sort | uniq | xargs -L1 sudo snap install --classic

    echo "installing snap packages..."
    /bin/cat $file | /bin/grep -v classic | /bin/awk -F' ' '{print $1}' | \
        sort | uniq | tr '\n' ' ' | xargs sudo snap install
}
