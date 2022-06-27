#!/bin/zsh

reset

source ~/workspaces/bernardolm/dotfiles/shell/debug.sh
source ~/workspaces/bernardolm/dotfiles/shell/find.sh
source ~/workspaces/bernardolm/dotfiles/shell/progress_bar.sh

local function find_cmd() {
    find_to_array $HOME/zsh_history/ -type f -size +1G
}

local function shrink_and_move() {
    local file=$1
    local now=`date +"%Y%m%d%H%M%S%N"`
    local dst="$HOME/zsh_history_light/histfile_::now::_$2"
    local dst=`echo $dst | sed "s/::now::/$now/g"`

    echo zsh-history-clear --file "$file" 1>/dev/null
    mv "$file" "$dst"
}

local function how_many_threads_running() {
    ps aux | grep "zsh-history-clear --file" | grep -v grep | wc -l | bc
}

local files_processed=0
local threads_limit=6

while true; do
    files=`find_cmd`
    files_count=`items_counter "$files"`

    while [ $files_count -eq 0 ]; do
        # clear
        echo -n 💤
        sleep 1
        files=`find_cmd`
        files_count=`items_counter "$files"`
    done

    # clear

    find_cmd | while read file; do
        local threads_running=`how_many_threads_running`
        echo_var threads_running

        while [ $threads_running -ge $threads_limit ]; do
            sleep .5
            threads_running=`how_many_threads_running`
            echo_var threads_running
        done

        ((files_processed+=1))
        `shrink_and_move "$file" $files_processed` &

        # tput cuu1; tput cuu1; tput el
        progress_bar $threads_running $threads_limit "$files_processed | $file"
    done
done
