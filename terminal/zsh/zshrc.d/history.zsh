# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
export HISTFILE="$HOME/sync/linux/home/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=100000

if [ -f "$HOME/.zsh_history" ]; then
	echo merging zsh_history in home
	cat "$HOME/.zsh_history" >> "$HISTFILE"
	rm -f "$HOME/.zsh_history"
fi

if [ -f "$ZDOTDIR/.zsh_history" ]; then
	echo merging zsh_history in zdotdir
	cat "$ZDOTDIR/.zsh_history" >> "$HISTFILE"
	rm -f "$ZDOTDIR/.zsh_history"
fi
