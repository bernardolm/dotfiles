function ohmyzsh_plugins_list() {
    /bin/cat "$DOTFILES/addons/ohmyzsh-plugins.txt" | grep -v '#' | grep -v '/' | while read -r file ; do
        plugins="$plugins\n$file"
    done
    echo -n $plugins
}

function ohmyzsh_docker_completions() {
    [ ! -f "$ZSH/plugins/docker/_docker" ] && \
        curl -fLo "$ZSH/plugins/docker/_docker" \
        'https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker'
}

function ohmyzsh_bundles_init() {
    find "$HOME/.antigen/bundles" -maxdepth 3 -name '*.plugin.zsh' | \
        grep -v 'bundles/robbyrussell' | \
        while read -r file; do
        $DEBUG_SHELL && _info "ohmyzsh_bundles_init: ${file}"
        source $file
    done
}

export ZSH="$HOME/.antigen/bundles/robbyrussell/oh-my-zsh"
export ZSH_THEME=robbyrussell

if [ ! -d "$ZSH" ]; then
    $DEBUG_SHELL && _warn "Couldn't find oh-my-zsh root path with '$ZSH'"
else
    $DEBUG_SHELL && _info "found '$ZSH' as oh-my-zsh root path"

    plugins=($(ohmyzsh_plugins_list))
    $DEBUG_SHELL && _info "oh-my-zsh plugins='$plugins'"

    source $ZSH/oh-my-zsh.sh

    ohmyzsh_bundles_init

    # Docker completions
    ohmyzsh_docker_completions

    chmod +x ~/.local/bin/register-python-argcomplete
fi
