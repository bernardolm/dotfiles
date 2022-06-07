function backup_apt_packages() {
    mkdir -p $SYNC_PATH/apt-packages/
    [ -f $SYNC_PATH/apt-packages/$(hostname)_current.txt ] && mv \
        $SYNC_PATH/apt-packages/$(hostname)_current.txt $SYNC_PATH/apt-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    dpkg --get-selections > $SYNC_PATH/apt-packages/$(hostname)_current.txt
}

function restore_apt_packages() {
    function run() {
        local filter
        local action=$1
        local nc='\033[0m'
        local cyan='\033[0;36m'
        local yellow='\033[1;33m'
        local file=$(last_backup_version apt-packages txt)

        if [[ "$action" == "install" ]]; then
            filter="/bin/grep -v deinstall";
        elif [[ "$action" == "purge" ]]; then
            filter="/bin/grep deinstall";
        fi

        # start message
        echo "$cyan$action apt packages from $yellow$file$cyan...$nc"

        local counter=0
        local packages=($(/bin/cat $file | sed '/^$/d' | eval $filter | /bin/awk -F' ' '{print $1}' ORS=' ' | sort -r))
        local packages_len=${#packages[@]}
        local packages_valid=()

        # found message
        echo "$yellow${#packages[@]}$cyan found$nc\c"
        [[ -z $packages ]] && echo "\n" && return

        # filter valid message
        echo "$cyan, now filtering valid packages...$nc"

        for package in $packages; do
            ((counter+=1))
            progress_bar $counter $packages_len
            apt show "$package" 2>/dev/null | grep -qvz 'State:.*(virtual)' && packages_valid+=($package);
        done

        # valid found message
        echo "\n$yellow${#packages_valid[@]}$cyan valid packages$nc"

        sudo apt $action --yes $packages_valid 2>/dev/null
    }

    run "install"
    run "purge"
}
