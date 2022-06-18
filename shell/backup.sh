function backup_all() {
    # TODO:
    # [ ] backup resolve.conf.d files

    backup_apt_packages
    backup_crontab
    backup_git_workspaces $WORKSPACE_ORG org
    backup_git_workspaces $WORKSPACE_USER user
    backup_gnome
    backup_guake
    backup_python_packages
    backup_repositories_config &> /dev/null
    backup_snap_packages
    backup_symbolic_links
}

function backup_it() {
    cp --preserve=all --recursive $1 $1_$(date +"%Y%m%d%H%M%S%N")
}

function merge_backup() {
    local folder=$1
    local ext=$2
    local search_in=$SYNC_PATH/$folder

    echo "working on $search_in with ext *.$ext"

    local new="$search_in/$(date +"%Y%m%d%H%M%S%N").$ext.new"

    [ ! -f $new ] && touch $new

    local files=(`find $search_in -type f -name "*.$ext" -printf '"%p" '`)
    [ ${#files[@]} -eq 0 ] && return

    eval "/bin/cat --squeeze-blank $files | sort -u > $new"
    eval "gio trash $files"
    mv "$new" "$search_in/current.$ext"
}

function merge_all_backups() {
    merge_backup apt-packages txt
    merge_backup git-workspaces csv
    merge_backup python-packages txt
    merge_backup snap-packages txt
    merge_backup symbolic-links csv
    merge_backup vpn-custom-routes csv
}
