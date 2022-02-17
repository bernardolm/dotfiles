function backup_apt_packages() {
    mkdir -p $SYNC_PATH/apt-packages/
    mv $SYNC_PATH/apt-packages/$(hostname)_current.txt $SYNC_PATH/apt-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    dpkg --get-selections > $SYNC_PATH/apt-packages/$(hostname)_current.txt
}

function restore_apt_packages() {
    local 'file'
    file=$(last_backup_version apt-packages txt)

    sudo apt update

    echo "restoring apt packages..."
    /bin/cat $file | /bin/grep -v deinstall | /bin/awk -F' ' '{print $1}' ORS=' ' | xargs sudo apt install --yes

    echo "removing unused apt packages..."
    /bin/cat $file | /bin/grep deinstall | /bin/awk -F' ' '{print $1}' ORS=' ' | xargs sudo apt purge --yes
}
