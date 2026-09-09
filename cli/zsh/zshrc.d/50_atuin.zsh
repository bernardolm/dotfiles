# export ATUIN_LOG=debug
export ATUIN_LOG=info
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"
