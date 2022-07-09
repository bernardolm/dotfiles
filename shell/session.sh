function start_zsh_session() {
    zsh_start_session=/tmp/zsh_session
    [ ! -d $zsh_start_session ] && mkdir -p /tmp/zsh_session
    zsh_start_session+=_`date +"%Y%m%d%H%M%S%N"`
    touch $zsh_start_session
    export ZSH_SESSION=$zsh_start_session
    alias source="source_and_log_session"
}

function log_zsh_session() {
    file=`realpath $1`
    [ -e "$ZSH_SESSION" ] \
        && { echo $file | tee -a $ZSH_SESSION 1>/dev/null; }
}

function check_zsh_session() {
    file=`realpath $1`
    [ -e "$ZSH_SESSION" ] \
        && grep $file "$ZSH_SESSION" && return
    false
}

function finish_zsh_session() {
    echo "$(/bin/cat $ZSH_SESSION | wc -l) lines in deleted session"
    [ -f $ZSH_SESSION ] && /bin/rm $ZSH_SESSION
}

function source_and_log_session() {
    file=`realpath $1`

    $DEBUG_SHELL && echo -n "${ORANGE}checking if ${TAN}$file ${ORANGE}was loaded... "

    if [ `check_zsh_session $file` ]; then
        $DEBUG_SHELL && echo "${RED}yes!${NC}"
        return
    fi

    $DEBUG_SHELL && echo "${GREEN}nope${NC}"

    log_zsh_session $file

    source $file

    $DEBUG_SHELL && echo "${TAN}$file ${SKYBLUE}load finish${NC}"
}
