now=$(date +"%Y%m%d%H%M%S")
log_path=$HOME/tmp/refresh-all-git/$now
[ ! -d $log_path ] && mkdir -p $log_path

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

setopt ksh_arrays
colorize[0]="\033[0;31m"
colorize[1]="\033[0;32m"
colorize[2]="\033[0;33m"
colorize[3]="\033[0;34m"
colorize[4]="\033[0;35m"
colorize[5]="\033[0;36m"
colorize[6]="\033[0;37m"
colorize[7]="\033[1;30m"
colorize[8]="\033[1;31m"
colorize[9]="\033[1;32m"
colorize[10]="\033[1;33m"
colorize[11]="\033[1;34m"
colorize[12]="\033[1;35m"
colorize[13]="\033[1;36m"
colorize[14]="\033[1;37m"
nc="\033[0m" # No Color

wait_for=0

do_bkp() {
    local from="$1"
    local to="../_$2-bkp-$now"
    mv ${from} ${to}
}

update_repo() {
    local repo_name=$(basename $1)
    local this_log=${log_path}/${repo_name}.log
    touch ${this_log}

    cd $1

    local random_number=$(((RANDOM % 14) + 1))

    echo -e ${colorize[$RANDOM_NUMBER]} >>${this_log} 2>&1

    if [[ ${repo_name} =~ '^_+.*$' ]]; then
        echo -e "skipping ${repo_name}" >>${this_log} 2>&1
    elif [ -d ".git" ]; then
        echo -e "starting ${repo_name} after "$2"s" >>${this_log} 2>&1
        sleep $WAIT_FOR

        echo -e "fetching ${repo_name}" >>${this_log} 2>&1
        # git stash >>${this_log} 2>&1
        git fetch --all --prune >>${this_log} 2>&1
        # (git checkout master || git checkout main) >>${this_log} 2>&1
        # (git pull origin master || git pull origin main) >>${this_log} 2>&1
        echo -e "\n\n" >>${this_log} 2>&1

        if [[ $(cat ${this_log} | grep -c "Repository not found") > 0 ]]; then
            echo -e "backuping ${repo_name}, repository not found" >>${this_log} 2>&1
            do_bkp $1 ${repo_name}
        fi
    else
        echo -e "backuping ${repo_name}, is a obsolete repository" >>${this_log} 2>&1
        do_bkp $1 ${repo_name}
    fi

    echo -e ${NC} >>${this_log} 2>&1

    cat $this_log

    cd ..
}

iter_paths() {
    $(echo $1) | while read -r f; do
        if [[ $f == *"dotfiles"* ]]; then
            continue
        fi

        wait_for=$((wait_for + 2))
        update_repo $f $wait_for &
    done
}

iter_paths "find ${WORKSPACE_ORG} -mindepth 1 -maxdepth 1 -type d"
iter_paths "find ${WORKSPACE_USER} -mindepth 1 -maxdepth 1 -type d"

# iter_paths "find $GOPATH/src/github.com/$GITHUB_ORG -mindepth 1 -maxdepth 1 -type d"
# iter_paths "find $GOPATH/src/github.com/$GITHUB_USER -mindepth 1 -maxdepth 1 -type d"

# sleep $((WAIT_FOR + (15 * 60))) && /bin/rm -rf $log_path
