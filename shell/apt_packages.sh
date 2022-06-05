function backup_apt_packages() {
    mkdir -p $SYNC_PATH/apt-packages/
    [ -f $SYNC_PATH/apt-packages/$(hostname)_current.txt ] && mv \
        $SYNC_PATH/apt-packages/$(hostname)_current.txt $SYNC_PATH/apt-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    dpkg --get-selections > $SYNC_PATH/apt-packages/$(hostname)_current.txt
}

function restore_apt_packages() {
    local 'file'
    file=$(last_backup_version apt-packages txt)

    sudo apt update

    echo "\nrestoring apt packages from $file..."

    local 'packages'
    packages=($(/bin/cat $file | /bin/grep -v deinstall | /bin/awk -F' ' '{print $1}' ORS=' '))
    echo "${#packages[@]} packages found"
    
    local 'packages_len'
    packages_len=${#packages[@]}

    local 'packages_valid'
    packages_valid=()

    local 'counter'
    counter=0

    for package in $packages; do
        ((counter+=1))
        progress_bar $counter $packages_len
        apt show "$package" 2>/dev/null | grep -qvz 'State:.*(virtual)' && packages_valid+=($package);
    done

    echo "${#packages_valid[@]} valid packages to install"

    sudo apt install --yes $packages_valid

    ---

    # TODO: Don't duplicate code

    echo "\nremoving unsed apt packages from $file..."

    local 'packages'
    packages=($(/bin/cat $file | /bin/grep deinstall | /bin/awk -F' ' '{print $1}' ORS=' '))
    echo "${#packages[@]} packages found to remove"
    
    local 'packages_len'
    packages_len=${#packages[@]}

    local 'packages_valid'
    packages_valid=()

    local 'counter'
    counter=0
    
    for package in $packages; do
        ((counter+=1))
        echo "$counter/$packages_len"
        apt show "$package" 2>/dev/null | grep -qvz 'State:.*(virtual)' && packages_valid+=($package);
    done

    echo "${#packages_valid[@]} valid packages to remove"

    sudo apt purge --yes $packages_valid
}
