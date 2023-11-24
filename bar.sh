#!/usr/bin/env zsh

reset

local command

command="git mv --force --verbose"

local git_move

function git_move() {
    source=$1
    destination=$2

    if [ ! -f $source ]; then
        touch $source
    fi

    backup_path="${destination}.backup"

    if [ -f $destination ] && [ ! -f $backup_path ]; then
        mv -f $destination $backup_path
    fi

    eval $command $source $destination

    mv -f  $backup_path    $destination

    echo ""
}

git_move zsh/functions/dummy_function_file antigen/functions/dummy_function_file
