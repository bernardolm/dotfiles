function backup_symbolic_links() {
    mkdir -p $SYNC_PATH/symbolic-links/

    [ -f $SYNC_PATH/symbolic-links/$(hostname)_current.csv ] && mv \
        $SYNC_PATH/symbolic-links/$(hostname)_current.csv $SYNC_PATH/symbolic-links/$(hostname)_$(date +"%Y%m%d%H%M%S").csv

    find / -type l -ls 2>/dev/null | awk -F" " '{print $13";"$11}\' | grep '/home/'$USER |
        grep -iv '.cache' |
        grep -iv '.dropbox-dist' |
        grep -iv '.ecryptfs' |
        grep -iv '.mozilla' |
        grep -iv '.oh-my-zsh/' |
        grep -iv '.old-gnome-config' |
        grep -iv '.wine' |
        grep -iv '/.themes/' |
        grep -iv '/.zinit/' |
        grep -iv '/app/' |
        grep -iv '/dev/null' |
        grep -iv '/java.base/' |
        grep -iv '/pid-' |
        grep -iv '/proc' |
        grep -iv '/tmp/' |
        grep -iv 'alerts/glass.ogg' |
        grep -iv 'alerts/sonar.ogg' |
        grep -iv 'applications-merged' |
        grep -iv 'arduino' |
        grep -iv 'chrome' |
        grep -iv 'darwin' |
        grep -iv 'genymotion' |
        grep -iv 'gnome-shell/extensions/' |
        grep -iv 'gopath' |
        grep -iv 'linux' |
        grep -iv 'lutris' |
        grep -iv 'node_modules' |
        grep -iv 'OMZ::plugins' |
        grep -iv 'Rambox' |
        grep -iv 'share/Trash' |
        grep -iv 'snap' |
        grep -iv 'studio3t/jre' |
        grep -iv 'systemd/user/pipewire' |
        grep -iv 'venv/' |
        grep -iv 'webkitgtk' |
        grep -iv 'zinit/plugins' |
        grep -iv $GITHUB_ORG \
            >> $SYNC_PATH/symbolic-links/$(hostname)_current.csv
}

function restore_symbolic_links() {
    local 'file'
    file=$(last_backup_version symbolic-links csv)

    NOW=$(date +"%Y%m%d%H%M%S")

    while read line; do
        function ln_smart() {
            from=$1
            to=$2
            skipBackup=$3

            if [[ "$to" == "/home"* ]]; then
                [ ! $skipBackup ] && echo -n "backuping... " && mv $to "$to-bkp-$NOW"
                echo -n "linking $from to $to... "
                ln -sf $from $to
            else
                [ ! $skipBackup ] && echo -n "backuping with sudo... " && sudo mv $to "$to-bkp-$NOW"
                echo -n "linking with sudo $from to $to... "
                sudo ln -sf $from $to
            fi

            echo -ne "finish\n"
        }

        IFS=';' read -r from to <<< "$line"

        echo -n "checking $to... "

        if test -L $to; then
            echo -ne "is a symlink, skipping\n"
        elif test -d $to; then
            if test -L $to; then
                echo -ne "is a symlink to a directory\n"
            else
                echo -n "is a plain directory... "
                ln_smart $from $to
            fi
        elif test -f $to; then
            if test -L $to; then
                echo -ne "is a symlink to a file\n"
            else
                echo -n "is a plain file... "
                ln_smart $from $to
            fi
        else
            echo -n "don't exist... "
            ln_smart $from $to true
        fi
    done < $file
}
