#!/bin/bash

source ./shell/init/env.sh
source ./shell/init/functions_loader.sh

msg_start 'todo.txt-cli'

if [ ! -f ~/.local/bin/todo.sh ]; then
    version="2.12.0"
    curl -s -L https://github.com/todotxt/todo.txt-cli/releases/download/v$version/todo.txt_cli-$version.zip -o ~/tmp/todo.zip
    unzip ~/tmp/todo.zip -d ~/tmp/todo
    yes | mv ~/tmp/todo/todo.txt_cli-$version.dirty/todo.sh ~/.local/bin/todo.sh
fi

msg_end 'todo.txt-cli'
