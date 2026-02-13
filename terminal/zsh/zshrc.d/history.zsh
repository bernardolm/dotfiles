export HISTSIZE="${HISTSIZE:-100000}"
export SAVEHIST="${SAVEHIST:-100000}"

dotfiles_history_official="$HOME/sync/.zsh_history"
dotfiles_history_current="${HISTFILE:-}"
export HISTFILE="$dotfiles_history_official"

mkdir -p "$(dirname "$HISTFILE")"
touch "$HISTFILE"

history_merge_script="$HOME/dotfiles/bin/zsh_history_merge.py"
history_merge_lock="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-zsh-history-merge.lock"
history_previous_file="${DOTFILES_HISTFILE_PREVIOUS:-}"
unset DOTFILES_HISTFILE_PREVIOUS

resolve_python_cmd() {
	if command -v pyenv >/dev/null 2>&1; then
		echo "pyenv exec python"
		return 0
	fi
	if command -v python3 >/dev/null 2>&1; then
		echo "python3"
		return 0
	fi
	if command -v python >/dev/null 2>&1; then
		echo "python"
		return 0
	fi
	return 1
}

run_history_merge_async() {
	local python_cmd=""
	local -a command_line=()
	local -a previous_files=()
	local previous_joined=""
	local legacy_joined=""

	[ -f "$history_merge_script" ] || return 0
	python_cmd="$(resolve_python_cmd 2>/dev/null || true)"
	[ -n "$python_cmd" ] || return 0

	if [[ "$python_cmd" == "pyenv exec python" ]]; then
		command_line=(pyenv exec python "$history_merge_script")
	else
		command_line=("$python_cmd" "$history_merge_script")
	fi

	if [ -n "$history_previous_file" ]; then
		previous_files+=("$history_previous_file")
	fi
	if [ -n "$dotfiles_history_current" ]; then
		previous_files+=("$dotfiles_history_current")
	fi

	if [ "${#previous_files[@]}" -gt 0 ]; then
		previous_joined="$(printf '%s:' "${previous_files[@]}")"
		previous_joined="${previous_joined%:}"
	fi

	legacy_joined="$HOME/.zsh_history:$ZDOTDIR/.zsh_history:${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"

	DOTFILES_ZSH_HISTORY_OFFICIAL_FILE="$HISTFILE" \
	DOTFILES_ZSH_HISTORY_HOME_DIR="$HOME" \
	DOTFILES_ZSH_HISTORY_LOCK_DIR="$history_merge_lock" \
	DOTFILES_ZSH_HISTORY_SCAN_PATTERN="*zsh_history*" \
	DOTFILES_ZSH_HISTORY_LEGACY_FILES="$legacy_joined" \
	DOTFILES_ZSH_HISTORY_PREVIOUS_FILES="$previous_joined" \
	"${command_line[@]}" >/dev/null 2>&1
}

run_history_merge_async &!
