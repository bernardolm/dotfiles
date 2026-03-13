
autoload -Uz vcs_info
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
precmd_functions+=(vcs_info)

setopt prompt_subst

# zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b)'

export RPROMPT="${vcs_info_msg_0_} $RPROMPT"

# export GIT_TRACE=1
# export GIT_CURL_VERBOSE=1

alias gb='git branch'
alias gbd='git branch -D'
alias gbr='git branch --remote'
alias gc='git commit'
alias gco='git checkout'
alias gfp='git fetch --prune'
alias ggpull='git pull origin'
alias ggpush='git push origin'
alias ggsync='git stash --all && ggpull && ggpush && git stash pop'
alias gsl='git stash list'
alias gst='git status'
