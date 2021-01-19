function show_git_repo_info() {
    [ -d $1 ] && [ -d $1/.git ] &&
        for r in $(git --git-dir=$1/.git --work-tree=$1 remote); do
            echo -n $r";" &&
                echo -n $(git --git-dir=$1/.git --work-tree=$1 remote get-url --all $r)";" &&
                echo -ne $1"\n"
        done
}

function backup_git_workspaces() {
    for d in $1/*; do show_git_repo_info $d; done | tee $SYNC_PATH/git_workspaces_$2 >/dev/null
}

function restore_git_workspaces() {
    while read line; do
        IFS=';' read -r -a paths <<<"$line"
        origin_name=${paths[0]}
        remote_url=${paths[1]}
        local_path=${paths[2]}

        if [ ! -d $local_path ]; then
            git clone $remote_url $local_path
        fi
    done <$1
}
