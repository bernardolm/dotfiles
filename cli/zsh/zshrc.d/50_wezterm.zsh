# Publishes the running command to WezTerm as the WEZTERM_PROG user var, cleared when the prompt comes back. cli/wezterm/format-tab-title.lua reads it to put the app name in the tab title, since panes on the unix mux domain don't expose foreground_process_name.
[[ -n "$WEZTERM_PANE" ]] || return 0

__wezterm_set_user_var() {
	printf '\033]1337;SetUserVar=%s=%s\007' "$1" "$(printf '%s' "$2" | base64 | tr -d '\n')"
}

__wezterm_prog_preexec() {
	__wezterm_set_user_var WEZTERM_PROG "$1"
}

__wezterm_prog_precmd() {
	printf '\033]1337;SetUserVar=WEZTERM_PROG=\007'
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec __wezterm_prog_preexec
add-zsh-hook precmd __wezterm_prog_precmd
