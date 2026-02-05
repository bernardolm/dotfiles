alias dcla='docker ps -a'
alias dclsa=dcla

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
# compinit
# End of Docker CLI completions


PATH=$PATH:$HOMEo/.docker/bin
