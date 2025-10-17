((SHELL_DEBUG)) && echo ".zshrc"
source "$DOTFILES/zsh/start"

# atuin init zsh - just for atuin installation don't touch this file
# BUN_INSTALL - just for reflex installation don't touch this file

# bun
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"
