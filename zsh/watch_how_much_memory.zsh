function watch_how_much_memory() {
	watch -c -n1 -x bash -c "source_and_log_session $DOTFILES/zsh/how_much_memory.zsh; how_much_memory $1"
}
