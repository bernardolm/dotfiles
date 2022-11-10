function antigen_start() {
    source "$ANTIGEN"
}

$DEBUG_SHELL && \
    source "$DOTFILES/zsh/antigen.zsh" && \
    antigen_purge

export ANTIGEN="$SYNC_PATH/bin/antigen.zsh"

if [ ! -f "$ANTIGEN" ]; then
    $DEBUG_SHELL && _info "antigen not found ($ANTIGEN), installing..."

    curl --fail --show-error --silent -L git.io/antigen > "$ANTIGEN"

    antigen_start

    antigen use oh-my-zsh

    /bin/cat $DOTFILES/antigen/plugins.txt | grep -v '#' | while read -r pkg; do
        antigen bundle $pkg
    done

    /bin/cat $DOTFILES/ohmyzsh/plugins.txt | grep -v '#' | while read -r pkg; do
        antigen bundle $pkg
    done

    antigen apply

    # antigen cache-gen
else
    antigen_start
fi
