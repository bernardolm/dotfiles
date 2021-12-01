$DEBUG_SHELL && typeset -g ZPLG_MOD_DEBUG=1

setopt promptsubst

# zinit snippet OMZL::git.zsh

zinit_plugins=(
    johanhaleby/kubetail
    spaceship-prompt/spaceship-prompt
    zdharma-continuum/history-search-multi-word
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    zsh-users/zsh-syntax-highlighting
    zdharma-continuum/zinit-annex-as-monitor
    zdharma-continuum/zinit-annex-bin-gem-node
    zdharma-continuum/zinit-annex-patch-dl
    zdharma-continuum/zinit-annex-rust
)

for p in ${zinit_plugins[@]}; do
    if [ $DEBUG_SHELL ]; then
        $DEBUG_SHELL && echo "zinit plugin being loaded $p..."
        zinit load $p
    else
        zinit light $p
    fi
done
$DEBUG_SHELL && echo "zinit plugins loaded"

$DEBUG_SHELL && zinit times
 
autoload -Uz compinit
compinit
