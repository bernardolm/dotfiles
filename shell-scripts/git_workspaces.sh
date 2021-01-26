function show_git_repo_info() {
    [ -d $1 ] && [ -d $1/.git ] &&
        for r in $(git --git-dir=$1/.git --work-tree=$1 remote); do
            echo -n $r";" &&
                echo -n $(git --git-dir=$1/.git --work-tree=$1 remote get-url --all $r)";" &&
                echo -ne $1"\n"
        done
}

function backup_git_workspaces() {
    [[ "$1" == "" ]] && echo "you need pass the root path and alias for this. i.e.: backup_git_workspaces ~/my_workspace user" && return 1
    for d in $1/*; do show_git_repo_info $d; done | tee -a $SYNC_PATH/git_workspaces_$2 >/dev/null
}

function restore_git_workspaces() {
    while read line; do
        if [[ `ps -p $$ -ocomm=` == "zsh" ]]; then
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
            git clone $remote_url $local_path
            echo "-------------"
        fi
    done <$1
}
