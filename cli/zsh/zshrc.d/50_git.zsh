autoload -Uz vcs_info
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
precmd_functions+=(vcs_info)

setopt prompt_subst

# zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b)'

# export RPROMPT="${vcs_info_msg_0_} $RPROMPT"

# export GIT_TRACE=1
# export GIT_CURL_VERBOSE=1
