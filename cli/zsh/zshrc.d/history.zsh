export HISTSIZE="${HISTSIZE:-100000}"
export SAVEHIST="${SAVEHIST:-100000}"

# /bin/mv $HOME/tmp/.z* $HOME/sync

history_file="$HOME/sync/.zsh_history"
new_history_file="$HOME/sync/.zsh_history_new"
touch "$new_history_file"
mkdir -p "$HOME/tmp"

paths=("$HOME/sync" "$ZDOTDIR" "$HOME --maxdepth=1" "$HOME/Library/CloudStorage/Dropbox")

for p in "${paths[@]}"; do
	[ ! -d "$p" ] && continue

	find "$p" -type f -name '.zsh_history*' -and -not -name '*_new' 2>/dev/null |
		while read pp; do
			tee -a "$new_history_file" <"$pp" >/dev/null
			/bin/mv "$pp" "$HOME/tmp/$(basename $pp)"

		done
done

# /bin/ls -lah $HOME/sync/.z*

[ -f "$history_file" ] &&
	tee -a "$new_history_file" <"$history_file" >/dev/null &&
	/bin/rm "$history_file"

/bin/cat "$new_history_file" | grep "^:" | sort | uniq | tee "$history_file" >/dev/null

# /bin/ls -lah $HOME/sync/.z*

/bin/rm "$new_history_file"

# /bin/ls -lah $HOME/sync/.z*
