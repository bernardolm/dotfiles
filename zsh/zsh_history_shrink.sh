#!/bin/zsh

reset

source ~/workspaces/bernardolm/dotfiles/shell/debug.sh
source ~/workspaces/bernardolm/dotfiles/shell/find.sh
source ~/workspaces/bernardolm/dotfiles/shell/progress_bar.sh

local function find_cmd() {
    find_to_array $HOME/zsh_history/ -type f
}

local files_processed=0
local threads_limit=4

while true; do
    files=`find_cmd`
    files_count=`items_counter "$files"`

    while [ $files_count -eq 0 ]; do
        clear
        echo 💤
        sleep 1
        files=`find_cmd`
        files_count=`items_counter "$files"`
    done

    clear
    
    find_cmd | while read file; do
        local threads_running=`ps aux | grep "zsh-history-clear --file" | grep -v grep | wc -l | bc`

        while [ $threads_running -ge $threads_limit ]; do
            sleep .25
            threads_running=`ps aux | grep "zsh-history-clear --file" | grep -v grep | wc -l | bc`
        done

        local now=`date +"%Y%m%d%H%M%S%N"`
        bash -c "zsh-history-clear --file '$file' 1>/dev/null; mv '$file' '$HOME/zsh_history_light/histfile_${now}_${files_processed}'" 

        ((files_processed+=1))

        tput cuu1; tput cuu1; tput el
        progress_bar $threads_running $threads_limit "$files_processed | $file"
    done
done
