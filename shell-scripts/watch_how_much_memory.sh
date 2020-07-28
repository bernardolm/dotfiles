function watch_how_much_memory () {
	watch -c -n1 -x bash -c "source $WORKSPACE_USER/first-steps-ubuntu/shell-scripts/misc.sh; how_much_memory $1"
}
