local d="$WORKSPACE_USER/dircolors/.dircolors"
test -r $d && echo "dircolors!" && eval "$(dircolors --bourne-shell $d)"

source "$ANTIGEN_WORKDIR/bundles/dracula/zsh-syntax-highlighting/zsh-syntax-highlighting.sh"

# stop reading
return

if [ ! -f "$HOME/.local/bin/theme.sh" ]; then
	sudo curl -s -Lo $HOME/.local/bin/theme.sh 'https://git.io/JM70M'
	sudo chmod +x $HOME/.local/bin/theme.sh
fi

if command -v theme.sh > /dev/null; then
	[ -e ~/.theme_history ] && theme.sh "$(theme.sh -l|tail -n1)"

	# Optional

	# Bind C-o to the last theme.
	function last_theme() {
		theme.sh "$(theme.sh -l|tail -n2|head -n1)"
	}

	zle -N last_theme
	bindkey '^O' last_theme
fi
