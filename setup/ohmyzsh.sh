autoload -U compinit
compinit

plugins=($(cat $DOTFILES/ohmyzsh/plugins.txt | grep -v '#'))

if $DEBUG_SHELL; then
    echo -n "\noh-my-zsh plugins disabled: "
    for p in $(cat $DOTFILES/ohmyzsh/plugins.txt | grep '#'); do
        echo -n "$p, ";
    done
    echo ""
fi

for p in $plugins; do
    zinit snippet OMZP::$p/$p.plugin.zsh || true
done

zinit cdclear -q

source_and_log_session $ZSH/oh-my-zsh.sh
