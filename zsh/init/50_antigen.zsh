return

function antigen_start() {
    $DEBUG_SHELL && _debug "source $ANTIGEN_PATH/antigen.zsh"
    source "$ANTIGEN_PATH/antigen.zsh"
}

function antigen_purge() {
    $DEBUG_SHELL && _debug "antigen_purge"
    find "$HOME" -name '*.zwc' -delete
    rm -rf "$ANTIGEN_WORKDIR"
    rm "$HOME/.zcompdump*" 2>/dev/null; compinit
}

function antigen_install() {
    antigen_start

    $DEBUG_SHELL && _debug "antigen use oh-my-zsh"
    antigen use oh-my-zsh

    /bin/cat $DOTFILES/addons/ohmyzsh-plugins.txt | grep -v '#' | while read -r pkg; do
        $DEBUG_SHELL && _debug "antigen bundle ${pkg}"
        antigen bundle "${pkg}"
    done

    /bin/cat $DOTFILES/addons/zsh-plugins.txt | grep -v '#' | while read -r pkg; do
        $DEBUG_SHELL && _debug "antigen bundle ${pkg}"
        antigen bundle "${pkg}"
    done

    $DEBUG_SHELL && _debug "antigen theme robbyrussell"
    antigen theme robbyrussell

    $DEBUG_SHELL && _debug "antigen apply"
    antigen apply

    $DEBUG_SHELL && _debug "antigen cache-gen"
    antigen cache-gen
}

# export _ANTIGEN_INTERACTIVE=true
# export ANTIGEN_CACHE=false
# export _PARALLEL_BUNDLE=false
export ANTIGEN_PATH="$DOTFILES/antigen"
export ANTIGEN_WORKDIR="$HOME/.antigen"

$DEBUG_SHELL && antigen_purge

if [ ! -d "$ANTIGEN_WORKDIR" ]; then
    antigen_install
else
    antigen_start
fi
