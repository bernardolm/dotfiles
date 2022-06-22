#!/bin/zsh

reset

source ~/workspaces/bernardolm/dotfiles/shell/debug.sh
source ~/workspaces/bernardolm/dotfiles/shell/progress_bar.sh

local function files_counter() {
    eval "$find_cmd | wc -l | bc"
}

local limit=8
local processed=0
local find_cmd="find $HOME/zsh_history/ -type f -size -300M"
local files_count=`files_counter`

until [ $files_count -eq 0 ]; do
    (eval $find_cmd) | while read file; do
        local running=`ps aux | grep "zsh-history-clear --file" | grep -v grep | wc -l | bc`
        ((processed+=1))
        tput cuu1
        tput cuu1
        tput el
        echo "$processed/$files_count - \"$file\"\n"
        progress_bar $running $limit
        while [ $running -ge $limit ]; do
            sleep .5
            running=`ps aux | grep "zsh-history-clear --file" | grep -v grep | wc -l | bc`
        done
        local now=`date +"%Y%m%d%H%M%S%N"`
        bash -c "zsh-history-clear --file \"$file\" 1>/dev/null; mv \"$file\" $HOME/zsh_history_light/histfile_${processed}_${now}" &
    done
    files_count=`files_counter`
    while [ $files_count -eq 0 ]; do sleep 1; files_count=`files_counter`; done
done
