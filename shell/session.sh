#!/bin/bash

start_zsh_session() {
    local zsh_start_session=/tmp/zsh_session
    ZSH_TOTAL=100
    if [ ! -d $zsh_start_session ]; then
        mkdir -p $zsh_start_session
    else
        local file
        file=$(find "$zsh_start_session" -type f | tail -1)
        if [ -n "$file" ]; then
            ZSH_TOTAL=$(/bin/cat -b "$file" | wc -l)
        fi
        $DEBUG_SHELL && printf "loading %d scripts...\n" "$ZSH_TOTAL"
    fi
    export ZSH_TOTAL
    zsh_start_session+='/'$(date +"%Y%m%d%H%M%S%N")
    touch "$zsh_start_session"
    export ZSH_SESSION=$zsh_start_session
    alias source="source_and_log_session"
}

log_zsh_session() {
    local file
    file=$(realpath "$1")
    [ -e "$ZSH_SESSION" ] \
        && { echo "$file" | tee -a "$ZSH_SESSION" 1>/dev/null; }
}

check_zsh_session() {
    local file
    file=$(realpath "$1")
    [ -e "$ZSH_SESSION" ] \
        && grep "$file" "$ZSH_SESSION" && return
    false
}

finish_zsh_session() {
    # shellcheck source=/dev/null
    command -v progress_bar &>/dev/null || . "$DOTFILES/shell/progress_bar.sh"

    if [ -n "$ZSH_SESSION" ]; then
        local position
        position=$(/bin/cat -b "$ZSH_SESSION" | wc -l)
        if [ -n "$position" ]; then
            if [ "$position" -le "$ZSH_TOTAL" ]; then
                progress_bar "$position" "$ZSH_TOTAL"
            fi
            if [ "$position" -eq "$ZSH_TOTAL" ]; then
                echo "$position lines in deleted session"
            fi
        fi
    fi
}

source_and_log_session() {
    local file checked
    file=$(realpath "$1")
    checked=$(check_zsh_session "$file")

    $DEBUG_SHELL && echo -n "${ORANGE}checking if ${TAN}$file ${ORANGE}was loaded... "

    if [ "$checked" ]; then
        $DEBUG_SHELL && echo "${RED}yes!${NC}"
        return
    fi

    $DEBUG_SHELL && echo "${GREEN}nope${NC}"

    log_zsh_session "$file"
    # shellcheck source=/dev/null
    . "$file"
    finish_zsh_session

    $DEBUG_SHELL && echo "${TAN}$file ${SKYBLUE}load finish${NC}"
}
