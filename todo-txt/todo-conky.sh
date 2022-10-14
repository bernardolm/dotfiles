#!/bin/zsh

command -v todotxt_hide_footer || source $DOTFILES/zsh/todo_txt.zsh

todo.sh -cfP -d $TODO_DIR/todo-conky.cfg $@ | todotxt_hide_footer | todotxt_hide_create_date | todotxt_hide_project_and_context_symbols
