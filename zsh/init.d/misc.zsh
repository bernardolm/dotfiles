$SHELL_DEBUG && localectl status 1>/dev/null

[ -f "$HOME/.fzf.zsh" ] && . "$HOME/.fzf.zsh"

bindkey "^s" emoji::cli

if alias duf >/dev/null 2>&1; then
  unalias duf
fi
