if command -v docker >/dev/null 2>&1; then
	alias dcla='docker ps -a'
	alias dclsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
	alias di='docker images'
fi

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
if [ -d "$HOME/.docker/completions" ]; then
	fpath=("$HOME/.docker/completions" $fpath)
	# autoload -Uz compinit
	# compinit
fi
# End of Docker CLI completions

if [ -d "$HOME/.docker/bin" ] && [[ ":$PATH:" != *":$HOME/.docker/bin:"* ]]; then
	export PATH="$PATH:$HOME/.docker/bin"
fi
