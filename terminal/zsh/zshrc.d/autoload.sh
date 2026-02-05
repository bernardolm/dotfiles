command -v compinit >/dev/null || (autoload -Uz compinit && compinit) # Use default modern completion system, needs to be in top

# autoload -Uz promptinit && promptinit && prompt adam2 # Set up the prompt
autoload -Uz bashcompinit && bashcompinit # load some old bash completions
