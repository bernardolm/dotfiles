function show_git_repo_info() {
    [ -d $1 ] && [ -d $1/.git ] &&
        for r in $(git --git-dir=$1/.git --work-tree=$1 remote); do
            echo -n $r";" &&
            echo -n $(git --git-dir=$1/.git --work-tree=$1 remote get-url --all $r)";" &&
            echo -ne $1"\n"
        done
}

function get_path_part() {
    arrIN=(`echo $d | sed 's/\// /g'`)
    part=$(expr ${#arrIN[@]} - $2)
    echo ${arrIN[$part]}
}

function get_username() {
    get_path_part $1 1
}

function backup_git_workspaces() {
    [[ "$1" == "" ]] && echo "you need pass the root path and alias for this. i.e.: backup_git_workspaces ~/my_workspace_root_path" && return 1

    local file=$(last_backup_version git-workspaces csv)

    [ -f $file ] && mv \
        $file $SYNC_PATH/git-workspaces/$(hostname)_$(date +"%Y%m%d%H%M%S").csv

    for d in `find $1 -path '*/.git/config'`; do
        d=${d%/.git/config}
        # echo `get_username $d`";"`show_git_repo_info $d`
        show_git_repo_info $d | tee -a $file &>/dev/null
    ; done
}

function restore_git_workspaces() {
    local 'file'
    file=$(last_backup_version git-workspaces csv)

    while read line; do
        if [[ `which_shell` == "zsh" ]]; then
            parts=("${(@s/;/)line}")
            origin_name=${parts[1]}
            remote_url=${parts[2]}
            local_path=${parts[3]}
        else
            IFS=';' read -r -a parts <<<"$line"
            origin_name=${parts[0]}
            remote_url=${parts[1]}
            local_path=${parts[2]}
        fi

        if [ ! -d $local_path ]; then
            echo "origin_name=$origin_name"
            echo "remote_url=$remote_url"
            echo "local_path=$local_path"
            git clone $remote_url $local_path
            echo "---"
        fi
    done <$file
}
