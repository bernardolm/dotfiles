function start_zsh_session() {
    zsh_start_session=/tmp/zsh_session
    [ ! -d $zsh_start_session ] && mkdir -p $zsh_start_session

    export ZSH_TOTAL=$(ls -Art $zsh_start_session | tail -n1 | xargs -I{} /bin/cat -b {} | wc -l)
    $DEBUG_SHELL && echo "loading $ZSH_TOTAL scripts"

    zsh_start_session+='/'`date +"%Y%m%d%H%M%S%N"`
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
    command -v progress_bar &>/dev/null || source $DOTFILES/shell/progress_bar.sh

    local position=$(/bin/cat -b $ZSH_SESSION | wc -l)
    if [ $position -le $ZSH_TOTAL ]; then
        progress_bar $position $ZSH_TOTAL
    fi
    if [ $position -eq $ZSH_TOTAL ]; then
        echo "$position lines in deleted session"
    fi
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
    . $file
    finish_zsh_session

    $DEBUG_SHELL && echo "${TAN}$file ${SKYBLUE}load finish${NC}"
}
