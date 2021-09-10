function current_commit() {
    CURRENT_COMMIT=$(/usr/bin/git rev-parse --short HEAD)
    echo $CURRENT_COMMIT
}

function commits_ahead() {
    CURRENT_COMMIT=$1
    [[ "$CURRENT_COMMIT" == "" ]] && CURRENT_COMMIT=$(current_commit)
    /usr/bin/git log --oneline --reverse --ancestry-path $CURRENT_COMMIT..master
}

function next_commit() {
    CURRENT_COMMIT=$1
    [[ "$CURRENT_COMMIT" == "" ]] && CURRENT_COMMIT=$(current_commit)
    NEXT_COMMIT=$(commits_ahead | /bin/grep -v $CURRENT_COMMIT | head -n1 | awk '{print $1}')
    echo $NEXT_COMMIT
}

function pristine_checkout() {
    NEXT_COMMIT=$1
    /usr/bin/git checkout .
    /usr/bin/git clean -fdx
    /usr/bin/git checkout $NEXT_COMMIT
}

function go_to_next_commit() {
    CURRENT_COMMIT=$(current_commit)
    echo "current commit is $CURRENT_COMMIT..."
    NEXT_COMMIT=$(next_commit $CURRENT_COMMIT)
    echo "next commit is $NEXT_COMMIT..."
    pristine_checkout $NEXT_COMMIT 1> /dev/null 2>&1
}

function last_commit_with_file() {
    FILE=$1

    LOG=$2
    if [[ "$LOG" == "" ]]; then
        echo "seeking last commit with file $FILE..."
        LOG=$USER_TMP/last_commit_with_file/
        mkdir -p $LOG
        LOG=$LOG/$(date +"%Y%m%d%H%M%S").log
        touch $LOG
    fi

    LAST_COMMIT=$3

    CURRENT_COMMIT=$(current_commit)
    echo $CURRENT_COMMIT >> $LOG

    if [ -f $1 ]; then
        echo "file yet found, going head..."
        go_to_next_commit
        if [[ "$?" == "1" ]]; then
            echo "next_commit returns error, retrying"
            sleep 3
        fi
        last_commit_with_file $FILE $LOG $CURRENT_COMMIT
    else
        echo "file no more found, going back to $LAST_COMMIT"
        pristine_checkout $LAST_COMMIT 1> /dev/null 2>&1
        echo "finish"
    fi
}
