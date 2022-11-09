function git_current_commit() {
    CURRENT_COMMIT=$(/usr/bin/git rev-parse --short HEAD)
    echo $CURRENT_COMMIT
}

function git_commits_ahead() {
    CURRENT_COMMIT=$1
    [[ "$CURRENT_COMMIT" == "" ]] && CURRENT_COMMIT=$(git_current_commit)
    /usr/bin/git log --oneline --reverse --ancestry-path $CURRENT_COMMIT..master
}

function git_next_commit() {
    CURRENT_COMMIT=$1
    [[ "$CURRENT_COMMIT" == "" ]] && CURRENT_COMMIT=$(git_current_commit)
    NEXT_COMMIT=$(git_commits_ahead | /bin/grep -v $CURRENT_COMMIT | head -n1 | awk '{print $1}')
    echo $NEXT_COMMIT
}

function git_checkout_pristine() {
    NEXT_COMMIT=$1
    /usr/bin/git checkout .
    /usr/bin/git clean -fdx
    /usr/bin/git checkout $NEXT_COMMIT
}

function go_to_git_next_commit() {
    CURRENT_COMMIT=$(git_current_commit)
    echo "current commit is $CURRENT_COMMIT..."
    NEXT_COMMIT=$(git_next_commit $CURRENT_COMMIT)
    echo "next commit is $NEXT_COMMIT..."
    git_checkout_pristine $NEXT_COMMIT 1> /dev/null 2>&1
}

function git_commit_last_with_file() {
    FILE=$1

    LOG=$2
    if [[ "$LOG" == "" ]]; then
        echo "seeking last commit with file $FILE..."
        LOG=$USER_TMP/git_commit_last_with_file/
        mkdir -p $LOG
        LOG=$LOG/$(date +"%Y%m%d%H%M%S").log
        touch $LOG
    fi

    LAST_COMMIT=$3

    CURRENT_COMMIT=$(git_current_commit)
    echo $CURRENT_COMMIT >> $LOG

    if [ -f $1 ]; then
        echo "file yet found, going head..."
        go_to_git_next_commit
        if [[ "$?" == "1" ]]; then
            echo "git_next_commit returns error, retrying"
            sleep 3
        fi
        git_commit_last_with_file $FILE $LOG $CURRENT_COMMIT
    else
        echo "file no more found, going back to $LAST_COMMIT"
        git_checkout_pristine $LAST_COMMIT 1> /dev/null 2>&1
        echo "finish"
    fi
}

function git_clone_repos_by_url() {
    function start_log_file() {
        LOG_FILE=$1
        RANDOM_NUMBER=$(((RANDOM % 14) + 1))
        echo -e ${COLORS[$RANDOM_NUMBER]} >$LOG_FILE 2>&1
    }

    function print_last_line() {
        LOG_FILE=$1
        LAST_LINE=$(wc -l <$LOG_FILE)
        BEFORE_LAST_LINE=$(($LAST_LINE - 1))
        printf "$(sed -n 1p $LOG_FILE)"
        printf "$(sed -n ${BEFORE_LAST_LINE}p $LOG_FILE)"
        printf "$(sed -n ${LAST_LINE}p $LOG_FILE)"
        printf "\n"
    }

    function finalize_log_file() {
        LOG_FILE=$1
        ONLY_LAST_LINE=$2
        echo -e "\n"$NC >>$LOG_FILE 2>&1
        if [[ "$ONLY_LAST_LINE" == "only-last-line" ]]; then
            print_last_line $LOG_FILE;
            return;
        fi
        /bin/cat $LOG_FILE
    }

    function git_clone() {
        REPO_NAME=$1
        REPO_SSH_URL=$2
        THIS_LOG=$TMP/$REPO_NAME.log
        touch $THIS_LOG
        start_log_file $THIS_LOG

        echo -ne "cloning from $REPO_SSH_URL to $DEST/$REPO_NAME" >>$THIS_LOG 2>&1

        git clone --progress $REPO_SSH_URL $DEST/$REPO_NAME >>$THIS_LOG 2>&1

        if [[ $(/bin/cat $THIS_LOG | grep -c "make sure you have the correct access rights") > 0 ]]; then
            echo -ne "🔒 $REPO_NAME blocked, you can't see this" >>$THIS_LOG 2>&1;
            finalize_log_file $THIS_LOG "only-last-line";
            return;
        fi

        if [[ $(/bin/cat $THIS_LOG | grep -c "is not an empty directory") > 0 ]]; then
            echo -ne "✅  $REPO_NAME repository already exist" >>$THIS_LOG 2>&1;
            finalize_log_file $THIS_LOG "only-last-line";
            return;
        fi

        finalize_log_file $THIS_LOG
    }

    function iterate_page_result() {
        PAGE=$1
        /bin/cat $TMP/page_$PAGE.json | sed -r 's/\\"//g' | jq -r -c '.[]' | while read item; do
            git_clone $(jq -r -c '.name' <<<$item) $(jq -r -c '.ssh_url' <<<$item);
        done
    }

    function finalize() {
        echo "🏁  finished pages downloading"
    }

    function fetch() {
        URL=$1
        curl -s -u $GITHUB_USER:$TOKEN -D $TMP/page_$PAGE.txt -o $TMP/page_$PAGE.json $URL
    }

    function next_page() {
        /bin/cat $TMP/page_$PAGE.txt | grep 'link:' | sed -ne 's/.*\(http[^"]*\)>;\srel="next".*/\1/p'
    }

    URL=$1
    DEST=$2
    if [[ -z "${URL}" ]]; then echo "URL is required, nothing to do by now"; return; fi
    if [[ -z "${DEST}" ]]; then echo "dest path is required, nothing to do by now"; return; fi

    PAGE=$(echo $URL | /bin/sed -E 's/.*[^_]page=([0-9]+).*/\1/g')
    if [[ -z "${PAGE}" ]]; then echo "page can't be found, nothing to do by now"; return; fi

    NOW=$(date +"%Y%m%d%H%M%S")
    TMP=$USER_TMP/git-clone/$NOW
    TOKEN=$(git config github.token)

    echo "🌎 downloading page $PAGE from $URL to $DEST..."

    mkdir -p $TMP
    fetch $URL

    iterate_page_result $PAGE $DEST

    NEXT_PAGE=$(next_page)
    if [[ -z "${NEXT_PAGE}" ]]; then finalize; return; fi

    git_clone_repos_by_url $NEXT_PAGE $DEST
}

function git_repo_info() {
    [ -d $1 ] && [ -d $1/.git ] &&
        for r in $(git --git-dir=$1/.git --work-tree=$1 remote); do
            echo -n $r";" &&
            echo -n $(git --git-dir=$1/.git --work-tree=$1 remote get-url --all $r)";" &&
            echo -ne $1"\n"
        done
}

function git_workspaces_backup() {
    [[ "$1" == "" ]] && echo "you need pass the root path and alias for this. i.e.: backup_git_workspaces ~/my_workspace_root_path" && return 1

    local file=$(last_backup_version git-workspaces csv)

    [ -f $file ] && mv \
        $file $SYNC_PATH/git-workspaces/$(hostname)_$(date +"%Y%m%d%H%M%S").csv

    for d in `find $1 -path '*/.git/config'`; do
        d=${d%/.git/config}
        git_repo_info $d | tee -a $file &>/dev/null
    ; done
}

function git_workspaces_restore() {
    local file=$(last_backup_version git-workspaces csv)

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

function git_config_mass_replace() {
    for DIR in ./*; do
        if [ -d "$DIR" ]; then
            cd $DIR;
            sed -i.bak 's/'$1'/'$2'/g' .git/config;
            cd ..
        fi
    done
}
