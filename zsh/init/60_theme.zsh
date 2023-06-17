# local d="$WORKSPACE_USER/dircolors/.dircolors"
# test -r $d && eval "dircolors $d"

# eval dircolors <(curl -sL https://raw.githubusercontent.com/sorin-ionescu/dotfiles/master/dir_colors)

# stop reading
# return

if [ ! -f "$HOME/.local/bin/theme.sh" ]; then
	sudo curl -s -Lo $HOME/.local/bin/theme.sh 'https://git.io/JM70M'
	sudo chmod u+x $HOME/.local/bin/theme.sh
fi

if command -v theme.sh > /dev/null; then
	log_info "applying theme"

	[ -e ~/.theme_history ] && theme.sh "$(theme.sh -l|tail -n1)"

	# Bind C-o to the last theme.
	function last_theme() {
		theme.sh "$(theme.sh -l|tail -n2|head -n1)"
	}

	zle -N last_theme
	bindkey '^O' last_theme
else
	log_warn "theme.sh not found"
fi
