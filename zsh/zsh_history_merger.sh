#!/bin/zsh

reset

source ~/workspaces/bernardolm/dotfiles/shell/debug.sh
source ~/workspaces/bernardolm/dotfiles/shell/progress_bar.sh

local find_cmd_prefix="find $HOME/zsh_history_light -type f"

local function new_file_name() {
    local now=`date +"%Y%m%d%H%M%S%N"`
    echo "$HOME/zsh_history_light/histfile_000_${now}"
}

local function create_new_file() {
    local new_file=`new_file_name`
    touch $new_file
    echo $new_file
}

local function find_cmd() {
    echo "$find_cmd_prefix -not -name '$(basename -a $1)' | head -${files_limit}"
}

local function files_counter() {
    echo "$1" | wc -l | bc
}

local files_limit=10000
local lines_limit=2000000

local new_file=`new_file_name`
touch $new_file
local files=`eval "$(find_cmd $new_file)"`
local files_count=`files_counter $files`

until [ $files_count -eq 0 ]; do
    local files_processed=0

    (echo $files) | while read file; do
        /bin/cat $file >> $new_file
        local new_file_lines=`/bin/cat $new_file | wc -l | bc`
        mv "$file" $HOME/zsh_history_trash/`basename -a $file`

        ((files_processed+=1))

        progress_bar $files_processed $files_count "$new_file_lines | $new_file"
        
        if [ $new_file_lines -gt $lines_limit ]; then
            mv $new_file $HOME/zsh_history
            new_file=`new_file_name`
            touch $new_file
        fi
    done

    new_file=`new_file_name`
    touch $new_file

    files=`eval "$(find_cmd $new_file)"`
    files_count=`files_counter $files`

    while [ $files_count -lt $files_limit ]; do
        sleep $((5*60))
        files=`eval "$(find_cmd $new_file)"`
        files_count=`files_counter $files`
    done
done
