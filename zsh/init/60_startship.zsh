return

# export STARSHIP_CONFIG="$DOTFILES/starship/tokyo-night.toml"
export STARSHIP_CONFIG="$DOTFILES/starship/pastel-powerline.toml"

$DEBUG_SHELL && env STARSHIP_LOG=trace starship module rust
$DEBUG_SHELL && env STARSHIP_LOG=trace starship timings

eval "$(starship init zsh)"
