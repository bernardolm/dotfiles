[ -d $DOTFILES/todo-txt ] && export TODO_DIR=$DOTFILES/todo-txt

[ -d $TODO_DIR/.todo.actions.d ] && export TODO_ACTIONS_DIR=$TODO_DIR/.todo.actions.d

[ -f $SYNC_PATH/todo-txt/done.txt ] && export DONE_FILE=$SYNC_PATH/todo-txt/done.txt
[ -f $SYNC_PATH/todo-txt/report.txt ] && export REPORT_FILE=$SYNC_PATH/todo-txt/report.txt
[ -f $SYNC_PATH/todo-txt/todo.txt ] && export TODO_FILE=$SYNC_PATH/todo-txt/todo.txt

[ -f $TODO_DIR/todo_completion ] && source $TODO_DIR/todo_completion
[ -f $TODO_DIR/zsh.cfg ] && export TODOTXT_CFG_FILE=$TODO_DIR/zsh.cfg
