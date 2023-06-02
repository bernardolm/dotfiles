#!/usr/bin/env zsh
source ~/.zshrc

NOW=$(date +"%Y%m%d%H%M%S")

mkdir -p ~/tmp/git-update/${NOW}
TEMP_PATH=~/tmp/git-update/${NOW}

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

setopt ksh_arrays
COLORIZE[0]="\033[0;31m"
COLORIZE[1]="\033[0;32m"
COLORIZE[2]="\033[0;33m"
COLORIZE[3]="\033[0;34m"
COLORIZE[4]="\033[0;35m"
COLORIZE[5]="\033[0;36m"
COLORIZE[6]="\033[0;37m"
COLORIZE[7]="\033[1;30m"
COLORIZE[8]="\033[1;31m"
COLORIZE[9]="\033[1;32m"
COLORIZE[10]="\033[1;33m"
COLORIZE[11]="\033[1;34m"
COLORIZE[12]="\033[1;35m"
COLORIZE[13]="\033[1;36m"
COLORIZE[14]="\033[1;37m"
NC="\033[0m" # No Color

WAIT_FOR=0

do_bkp() {
    FROM="$1"
    TO="../_$2-bkp-${NOW}"
    mv ${FROM} ${TO}
}

update_repo() {
    REPO_NAME=$(basename $1)
    THIS_LOG=${TEMP_PATH}/${REPO_NAME}.log
    touch ${THIS_LOG}

    cd $1

    RANDOM_NUMBER=$(((RANDOM % 14) + 1))

    echo -e ${COLORIZE[$RANDOM_NUMBER]} >>${THIS_LOG} 2>&1

    if [[ ${REPO_NAME} =~ '^_+.*$' ]]; then
        echo -e "skipping ${REPO_NAME}" >>${THIS_LOG} 2>&1
    elif [ -d ".git" ]; then
        echo -e "starting ${REPO_NAME} after "$2"s" >>${THIS_LOG} 2>&1
        sleep $WAIT_FOR

        echo -e "fetching ${REPO_NAME}" >>${THIS_LOG} 2>&1
        git stash >>${THIS_LOG} 2>&1
        git fetch --all --prune >>${THIS_LOG} 2>&1
        git checkout master >>${THIS_LOG} 2>&1 || git checkout main >>${THIS_LOG} 2>&1
        git pull origin master >>${THIS_LOG} 2>&1 || git pull origin main >>${THIS_LOG} 2>&1
        echo -e "\n\n" >>${THIS_LOG} 2>&1

        if [[ $(cat ${THIS_LOG} | grep -c "Repository not found") > 0 ]]; then
            echo -e "backuping ${REPO_NAME}, repository not found" >>${THIS_LOG} 2>&1
            do_bkp $1 ${REPO_NAME}
        fi
    else
        echo -e "backuping ${REPO_NAME}, is a obsolete repository" >>${THIS_LOG} 2>&1
        do_bkp $1 ${REPO_NAME}
    fi

    echo -e ${NC} >>${THIS_LOG} 2>&1

    cat $THIS_LOG

    cd ..
}

iter_paths() {
    $(echo $1) | while read -r f; do
        if [[ $f == *"dotfiles"* ]]; then
            continue
        fi

        WAIT_FOR=$((WAIT_FOR + 1))
        update_repo $f $WAIT_FOR &
    done
}

iter_paths "find $WORKSPACE_ORG -mindepth 1 -maxdepth 1 -type d"
iter_paths "find $WORKSPACE_USER -mindepth 1 -maxdepth 1 -type d"

# iter_paths "find $GOPATH/src/github.com/$GITHUB_ORG -mindepth 1 -maxdepth 1 -type d"
# iter_paths "find $GOPATH/src/github.com/$GITHUB_USER -mindepth 1 -maxdepth 1 -type d"

sleep $((WAIT_FOR + (15 * 60))) && /bin/rm -rf $TEMP_PATH
