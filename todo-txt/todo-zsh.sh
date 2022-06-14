#!/bin/zsh

command -v todo.sh &> /dev/null || source $DOTFILES/shell/init/todo_txt.sh
command -v todotxt_hide_footer || source $DOTFILES/shell/todo_txt.sh

todo.sh -cANt -d $TODO_DIR/todo-zsh.cfg $@ | hide_create_date | highlight_project_and_context | hide_project_and_context_symbols
