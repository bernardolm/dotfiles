function backup_snap_packages() {
    mkdir -p $SYNC_PATH/snap-packages/
    mv $SYNC_PATH/snap-packages/$(hostname)_current.txt $SYNC_PATH/snap-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    snap list > $SYNC_PATH/snap-packages/$(hostname)_current.txt
}

function restore_snap_packages() {
    local 'file'
    local 'packages'
    local 'packages_classic'
    file=$(last_backup_version snap-packages)
    sudo snap refresh
    echo "installing classic snap packages"
    cat $file | grep -v Publisher | grep classic | cut -d' ' -f1 | xargs -n1 -d'\n' sudo snap install --classic
    echo "installing snap packages"
    cat $file | grep -v Publisher | grep -v classic | cut -d' ' -f1 | xargs -n1 -d'\n' sudo snap install
}
