[ -d $SYNC_PATH/todo-txt ] && export TODO_DIR=$SYNC_PATH/todo-txt
[ -d $TODO_DIR/.todo.actions.d ] && export TODO_ACTIONS_DIR=$TODO_DIR/.todo.actions.d
[ -f $TODO_DIR/done.txt ] && export DONE_FILE=$TODO_DIR/done.txt
[ -f $TODO_DIR/report.txt ] && export REPORT_FILE=$TODO_DIR/report.txt
[ -f $TODO_DIR/todo-zsh.cfg ] && export TODOTXT_CFG_FILE=$TODO_DIR/todo-zsh.cfg
[ -f $TODO_DIR/todo.txt ] && export TODO_FILE=$TODO_DIR/todo.txt

[ -f $TODO_DIR/todo_completion ] && source $TODO_DIR/todo_completion
