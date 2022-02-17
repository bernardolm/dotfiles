function backup_snap_packages() {
    mkdir -p $SYNC_PATH/snap-packages/
    [ -f $SYNC_PATH/snap-packages/$(hostname)_current.txt ] && mv \
        $SYNC_PATH/snap-packages/$(hostname)_current.txt $SYNC_PATH/snap-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    snap list > $SYNC_PATH/snap-packages/$(hostname)_current.txt
}

function restore_snap_packages() {
    local 'file'
    local 'packages'
    local 'packages_classic'
    file=$(last_backup_version snap-packages txt)

    sudo snap refresh

    echo "installing classic snap packages..."
    /bin/cat $file | /bin/grep -v Publisher | /bin/grep classic | /bin/awk -F' ' '{print $1}' ORS=' ' | xargs sudo snap install --classic

    echo "installing snap packages..."
    /bin/cat $file | /bin/grep -v Publisher | /bin/grep -v classic | /bin/awk -F' ' '{print $1}' ORS=' ' | xargs sudo snap install
}
