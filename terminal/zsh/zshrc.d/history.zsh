export HISTSIZE="${HISTSIZE:-100000}"
export SAVEHIST="${SAVEHIST:-100000}"

if [ -z "${HISTFILE:-}" ]; then
	export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
fi

mkdir -p "$(dirname "$HISTFILE")"

for legacy in "$HOME/.zsh_history" "$ZDOTDIR/.zsh_history"; do
	if [ -f "$legacy" ] && [ "$legacy" != "$HISTFILE" ]; then
		cat "$legacy" >> "$HISTFILE"
		rm -f "$legacy"
	fi
done
