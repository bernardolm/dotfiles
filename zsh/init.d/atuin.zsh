export ATUIN_NOBIND=true
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

bindkey "^R" atuin-search

# incremental history search with arrow keys
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward]]

function atuin_sync() {
	log start "atuin: background syncing"
	atuin import auto &>/dev/null
	atuin sync &>/dev/null
	log finish "atuin: background syncing"
}

atuin_sync &