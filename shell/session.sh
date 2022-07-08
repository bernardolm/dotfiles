function start_zsh_session() {
    zsh_start_session=/tmp/zsh_session
    [ ! -d $zsh_start_session ] && mkdir -p /tmp/zsh_session
    zsh_start_session+=_`date +"%Y%m%d%H%M%S%N"`
    touch $zsh_start_session
    export ZSH_SESSION=$zsh_start_session
}

function log_zsh_session() {
    [ -e "$ZSH_SESSION" ] && { echo $1 | tee -a $ZSH_SESSION 1>/dev/null; }
}

function check_zsh_session() {
    [ -e "$ZSH_SESSION" ] && grep "$1" "$ZSH_SESSION" && return
    false
}

function finish_zsh_session() {
    [ -f $ZSH_SESSION ] && /bin/rm $ZSH_SESSION
}

function source_and_log_session() {
    echo -n "${ORANGE}checking if ${TAN}$1 ${ORANGE}was loaded... "
    [ `check_zsh_session $1` ] && echo "${RED}yes!${NC}" && return
    echo "${GREEN}nope${NC}"
    log_zsh_session $1
    source $1
    echo "${TAN}$1 ${SKYBLUE}load finish${NC}"
}
