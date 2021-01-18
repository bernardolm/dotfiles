function install_oh_my_zsh() {
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    else
        echo "oh-my-zsh installed"
    fi

    if [ ! -d ${ZSH_CUSTOM1:-$ZSH/custom}/themes/spaceship-prompt ]; then
        git clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM1:-$ZSH/custom}/themes/spaceship-prompt"
        ln -sf "${ZSH_CUSTOM1:-$ZSH/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM1:-$ZSH/custom}/themes/spaceship.zsh-theme"
        echo "Set ZSH_THEME="spaceship" in your .zshrc."
    else
        echo "spaceship-prompt installed"
    fi

    if [ ! -d ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/alias-tips ]; then
        git clone https://github.com/djui/alias-tips.git "${ZSH_CUSTOM1:-$ZSH/custom}/plugins/alias-tips"
    else
        echo "alias-tips installed"
    fi

    if [ ! -d ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/kubetail ]; then
        git clone https://github.com/johanhaleby/kubetail.git "${ZSH_CUSTOM1:-$ZSH/custom}/plugins/kubetail"
    else
        echo "kubetail installed"
    fi

    if [ ! -d ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/zsh-completions ]; then
        git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM1:-$ZSH/custom}/plugins/zsh-completions"
    else
        echo "zsh-completions installed"
    fi

    if [ ! -d ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/zsh-syntax-highlighting ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM1:-$ZSH/custom}/plugins/zsh-syntax-highlighting"
    else
        echo "zsh-syntax-highlighting installed"
    fi

    if [ ! -d ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/zsh-wakatime ]; then
        git clone https://github.com/wbingli/zsh-wakatime.git "${ZSH_CUSTOM1:-$ZSH/custom}/plugins/zsh-wakatime"
    else
        echo "zsh-wakatime installed"
    fi
}
