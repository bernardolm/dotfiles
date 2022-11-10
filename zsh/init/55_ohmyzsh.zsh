export ZSH

ZSH="$HOME/.antigen/bundles/robbyrussell/oh-my-zsh"
[ ! -d "$ZSH" ] && ZSH=$(find ~ -name '*oh-my-zsh.sh' | xargs dirname)

plugins=""

/bin/cat "$DOTFILES/ohmyzsh/plugins.txt" | grep -v '#' | grep -v '/' | while read -r file ; do
    plugins="$plugins\n$file"
done

plugins=($(echo $plugins))

$DEBUG_SHELL && _info "oh-my-zsh plugins='$plugins'"

# Docker completions
[ ! -f "$ZSH/plugins/docker/_docker" ] && curl -fLo "$ZSH/plugins/docker/_docker" https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker

# Needed to load it's plugins
source "$ZSH/oh-my-zsh.sh"

find ~/.antigen/bundles -maxdepth 3 -name '*.zsh' | while read -r file; do
    source $file
done

chmod +x /home/bernardo/.local/bin/register-python-argcomplete
