function watch_how_much_memory() {
	watch -c -n1 -x bash -c "source $WORKSPACE_USER/dotfiles/shell-scripts/misc.sh; how_much_memory $1"
}
