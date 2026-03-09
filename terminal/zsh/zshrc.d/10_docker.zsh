if command -v docker >/dev/null 2>&1; then
	alias dcla='docker ps -a'
	alias dclsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
	alias di='docker images'
fi

if [ -d "$HOME/.docker/completions" ]; then
	fpath=("$HOME/.docker/completions" $fpath)
fi

if [ -d "$HOME/.docker/bin" ] && [[ ":$PATH:" != *":$HOME/.docker/bin:"* ]]; then
	export PATH="$PATH:$HOME/.docker/bin"
fi
