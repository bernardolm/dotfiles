function apt_backup() {
    mkdir -p $SYNC_PATH/apt-packages/
    [ -f $SYNC_PATH/apt-packages/$(hostname)_current.txt ] && mv \
        $SYNC_PATH/apt-packages/$(hostname)_current.txt $SYNC_PATH/apt-packages/$(hostname)_$(date +"%Y%m%d%H%M%S").txt
    dpkg --get-selections > $SYNC_PATH/apt-packages/$(hostname)_current.txt
}

function apt_sanitize() {
    sudo apt-get purge --yes \
        '^gnome-todo' \
        '^remmina' \
        '^rhythmbox' \
        '^thunderbird' \
        '^totem' \
        '^transmission' \
        aisleriot \
        deja-dup \
        glade \
        xserver-xorg-input-wacom \
        gnome-2048 \
        gnome-mahjongg \
        gnome-mines \
        gnome-sudoku \
        libreoffice-draw \
        libreoffice-impress \
        libreoffice-writer
}

function apt_restore() {
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

function apt_search_installed() {
    apt list --installed "*$1*" 2>/dev/null | awk -F'/' 'NR>1{print $1}'
}

function apt_get_keys() {
    local servers=(
        keys.gnupg.net
        keyserver.ubuntu.com
        subkeys.pgp.net
        keyserver.linuxmint.com
        ha.pool.sks-keyservers.net
    )

    local function apt_key() {
        local key=$1
        local server=$2
        set -e
        # sudo gpg --no-default-keyring --keyring /usr/share/keyrings/$key-archive-keyring.gpg --keyserver $server --recv-keys $key
        # sudo apt-key adv --keyserver $server --recv-keys $key
        parent_pid=$(ps -o ppid=`echo $PPID`)
        echo "⚠ killing $parent_pid, parent of $PPID"
        # sudo kill $parent_pid
    }

    local function search_and_add() {
        local key=$1
        for server in ${servers[@]}; do
            echo "searching key $1 on $server"
            apt_key $key $server &
        done
    }

    if [[ "$(command -v curl)" == "" ]]; then
        sudo apt-get install --yes curl
    fi

    sudo apt-get update 2>&1 1>/dev/null | sed -ne 's/.*NO_PUBKEY //p' | while read key; do
        echo "\n\n\n$key\n\n\n"
        # search_and_add $key &
    done
}
