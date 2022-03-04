function watch_how_much_memory() {
	watch -c -n1 -x bash -c "source $DOTFILES/shell/how_much_memory.sh; how_much_memory $1"
}
