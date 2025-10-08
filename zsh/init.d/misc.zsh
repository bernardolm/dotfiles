((SHELL_DEBUG)) && ((IS_LINUX)) && localectl status 1>/dev/null

[ -f "$HOME/.fzf.zsh" ] \
	&& source "$HOME/.fzf.zsh" \
	&& source /usr/share/fzf/completion.zsh

bindkey "^s" emoji::cli

if alias duf >/dev/null 2>&1; then
  unalias duf
fi
