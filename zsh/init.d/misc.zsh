$SHELL_DEBUG && localectl status 1>/dev/null

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.fzf.zsh" ] && . "$HOME/.fzf.zsh"
[ -d "${ZPLUG_HOME}/repos/b4b4r07/emoji-cli" ] \
    && . "${ZPLUG_HOME}/repos/b4b4r07/emoji-cli/emoji-cli.plugin.zsh"

if [ ! -h "${ZSH_CUSTOM}/plugins/wakatime" ] \
    && [ -d "${ZPLUG_HOME}/repos/sobolevn/wakatime-zsh-plugin" ]; then
    log info "(sym) linking wakatime-zsh-plugin"
    rm -rf "${ZSH_CUSTOM}/plugins/wakatime" >/dev/null
    ln -sf "${ZPLUG_HOME}/repos/sobolevn/wakatime-zsh-plugin" \
        "${ZSH_CUSTOM}/plugins/wakatime"
fi

if [ ! -h "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ] \
    && [ -d "${ZPLUG_HOME}/repos/zsh-users/zsh-autosuggestions" ]; then
    log info "(sym) linking zsh-autosuggestions"
    rm -rf "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" >/dev/null
    ln -sf "${ZPLUG_HOME}/repos/zsh-users/zsh-autosuggestions" \
        "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

bindkey "^s" emoji::cli

export PATH=$HOME/flutter/bin:$PATH
