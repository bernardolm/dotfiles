function merge_backup() {
    /bin/cat $SYNC_PATH/$1/* > $SYNC_PATH/$1/current.$2.tmp
    clear_backup $1 $2
    mv $SYNC_PATH/$1/current.$2.tmp $SYNC_PATH/$1/current.$2
}

function clear_backup() {
    find $SYNC_PATH/$1/*.$2 | /bin/grep -v /current.$2 | xargs trash
}

function merge_backups() {
    merge_backup apt-packages txt
    merge_backup git-workspaces csv
    merge_backup python-packages txt
    merge_backup snap-packages txt
    merge_backup symbolic-links csv
    merge_backup vpn-custom-routes csv
}
