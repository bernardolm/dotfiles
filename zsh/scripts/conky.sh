#!/usr/bin/env zsh

base_path="$(dirname $0)"
source $base_path/init/30_env.zsh
source $base_path/init/70_todotxt.zsh
source $base_path/todotxt.zsh
todo_conky $@
