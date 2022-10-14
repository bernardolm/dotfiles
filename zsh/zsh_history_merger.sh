#!/bin/zsh

reset

source ~/workspaces/bernardolm/dotfiles/zsh/debug.zsh
source ~/workspaces/bernardolm/dotfiles/zsh/find.zsh
source ~/workspaces/bernardolm/dotfiles/zsh/progress_bar.zsh

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
    find_to_array $HOME/zsh_history_light/ -type f -not -name '$(basename -a $1)' | head -${files_limit}
}

local files_limit=100
local lines_limit=100000
local lines_overall=0
local lines_total=0
local new_file_lines=0
local new_file=`new_file_name`
touch $new_file

while true; do
    files=`find_cmd $new_file`
    files_count=`items_counter "$files"`

    while [ $files_count -eq 0 ]; do
        clear
        echo 💤
        sleep 1
        files=`find_cmd $new_file`
        files_count=`items_counter "$files"`
    done

    clear

    local files_processed=0

    find_cmd | while read file; do
        local file_lines=`/bin/cat $file | wc -l | bc`
        ((lines_total+=$file_lines))
        ((lines_overall+=$lines_total))

        if [ $lines_total -gt $lines_limit ]; then
            lines_total=0
            mv "$new_file" "$HOME/zsh_history"
            new_file=`new_file_name`
            touch $new_file
        fi

        /bin/cat $file >> $new_file

        local trash_file=`basename -a "$file"`
        mv "$file" "$HOME/zsh_history_trash/$trash_file"

        ((files_processed+=1))

        progress_bar $files_processed $files_count "$file_lines >> $lines_overall | $new_file"
    done
done
