# Persist the last working directory used by interactive zsh shells.
typeset -g ZSH_LAST_WORKING_DIR_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/last-working-dir"

save_last_working_dir() {
	[[ "$ZSH_SUBSHELL" -eq 0 ]] || return 0
	local cache_dir="${ZSH_LAST_WORKING_DIR_FILE:h}"
	mkdir -p "$cache_dir"
	print -r -- "$PWD" >| "$ZSH_LAST_WORKING_DIR_FILE"
}

autoload -U add-zsh-hook
add-zsh-hook chpwd save_last_working_dir
save_last_working_dir
