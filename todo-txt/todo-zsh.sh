#!/bin/zsh

command -v todotxt_hide_create_date || source $DOTFILES/zsh/todo_txt.zsh

todo.sh -cANt -d $TODO_DIR/todo-zsh.cfg $@ | todotxt_hide_create_date | todotxt_highlight_project_and_context | todotxt_hide_project_and_context_symbols
