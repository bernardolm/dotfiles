function watch_how_much_memory() {
	watch -c -n1 -x bash -c "source $DOTFILES/shell/misc.sh; how_much_memory $1"
}
