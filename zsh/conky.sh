#!/usr/bin/zsh

base_path="$(dirname $0)"
source $base_path/init/30_env.zsh
source $base_path/init/70_todo_txt.zsh
source $base_path/todo_txt.zsh
todo_conky $@