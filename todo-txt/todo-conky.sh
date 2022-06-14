#!/bin/zsh

command -v todo.sh &> /dev/null || source $DOTFILES/shell/init/todo_txt.sh
command -v todotxt_hide_footer || source $DOTFILES/shell/todo_txt.sh

todo.sh -cfP -d $TODO_DIR/todo-conky.cfg $@ | todotxt_hide_footer | todotxt_hide_create_date | todotxt_hide_project_and_context_symbols
