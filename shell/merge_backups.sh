function merge_backup() {
    local folder=$1
    local ext=$2
    local search_in=$SYNC_PATH/$folder
    
    /bin/cat --squeeze-blank `ls $search_in` | sort -u > $search_in/current.$ext.new
    clear_backup $search_in $ext
    mv current.$ext.new current.$ext
}

function clear_backup() {
    local search_in=$1
    local ext=$2

    find $search_in -name "*.$ext" | xargs gio trash
}

function merge_all_backups() {
    merge_backup apt-packages txt
    merge_backup git-workspaces csv
    merge_backup python-packages txt
    merge_backup snap-packages txt
    merge_backup symbolic-links csv
    merge_backup vpn-custom-routes csv
}
