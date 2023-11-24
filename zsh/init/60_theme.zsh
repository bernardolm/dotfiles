return

if command -v theme.sh > /dev/null; then
	log info "applying theme"

	[ -e ~/.theme_history ] && theme.sh "$(theme.sh -l|tail -n1)"

	# Bind C-o to the last theme.
	function last_theme() {
		theme.sh "$(theme.sh -l|tail -n2|head -n1)"
	}

	zle -N last_theme
	bindkey '^O' last_theme
else
	log warn "theme.sh not found"
fi
