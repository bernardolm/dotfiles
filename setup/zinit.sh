function zinit_runner() {
    local params=($*)

    [ ${#params[@]} -le 1 ] \
        && echo "\"$params\" not enought params, exiting...\n" \
        && return false

    local cmd_mode=${params[1]}
    params=("${params[@]:1}")

    [[ ! "(debug turbo echo start)" =~ "$cmd_mode" ]] \
        && echo "\"$cmd_mode\" isn't a known command, exiting...\n" \
        && return false

    [[ "$cmd_mode" = "debug" ]] && cmd="zinit load"
    [[ "$cmd_mode" = "echo" ]] && cmd="echo -n"
    [[ "$cmd_mode" = "start" ]] && cmd="zinit light"
    [[ "$cmd_mode" = "turbo" ]] && cmd="zinit load" && zinit ice wait lucid

    if [ "$cmd_mode" != "echo" ]; then
        $DEBUG_SHELL && echo "zinit loading plugins with '$cmd_mode' mode ($cmd):"
        for p in $params; do
            $DEBUG_SHELL && echo "> $cmd $p"
            eval "$cmd $p"
        done
        $DEBUG_SHELL && echo "zinit $cmd_mode finished"
    else
        $DEBUG_SHELL && echo "zinit will not be loading follow plugins:"
        $DEBUG_SHELL && echo ${params[@]}
    fi

    $DEBUG_SHELL && echo ""
}

function start_zinit() {
    source $ZINIT_ROOT/zinit.git/zinit.zsh
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit
}

zinit_plugins_off=(
    zsh-users/zsh-syntax-highlighting
)

zinit_plugins=(
    zdharma-continuum/zinit-annex-as-monitor
    zdharma-continuum/zinit-annex-bin-gem-node
    zdharma-continuum/zinit-annex-patch-dl
    zdharma-continuum/zinit-annex-rust
)

xzinit_plugins_turbo=(
    # djui/alias-tips
    # rahulsalvi/velocity-python
    # unixorn/1password-op.plugin.zsh
    3v1n0/zsh-bash-completions-fallback
    ael-code/zsh-colored-man-pages
    b4b4r07/emoji-cli
    bric3/nice-exit-code
    brymck/print-alias
    chrissicool/zsh-256color
    commiyou/zsh-editing-workbench
    eastokes/aws-plugin-zsh
    folixg/gimme-ohmyzsh-plugin
    gmatheu/shell-plugins
    gretzky/auto-color-ls
    gryffyn/mouse-status
    jedahan/geometry-hydrate
    jgogstad/passwordless-history
    jimhester/per-directory-history
    johanhaleby/kubetail
    joshskidmore/zsh-fzf-history-search
    kazhala/dotbare
    laggardkernel/zsh-thefuck
    mafredri/zsh-async
    marlonrichert/zcolors
    marlonrichert/zsh-autocomplete
    mattmc3/zsh-safe-rm
    MenkeTechnologies/zsh-cargo-completion
    MichaelAquilina/zsh-auto-notify
    MichaelAquilina/zsh-you-should-use
    MisterRios/stashy
    molovo/revolver
    ohmyzsh/ohmyzsh
    paulmelnikow/zsh-startup-timer
    pschmitt/emoji-fzf.zsh
    QuarticCat/zsh-smartcache
    rawkode/zsh-docker-run
    reegnz/jq-zsh-plugin
    RobSis/zsh-completion-generator
    romkatv/zsh-bench
    se-jaeger/zsh-activate-py-environment
    sei40kr/fast-alias-tips-bin
    sei40kr/zsh-fast-alias-tips
    srijanshetty/docker-zsh
    srijanshetty/zsh-pip-completion
    sroze/docker-compose-zsh-plugin
    sunlei/zsh-ssh
    TamCore/autoupdate-oh-my-zsh-plugins
    Tarrasch/zsh-command-not-found
    unixorn/fzf-zsh-plugin
    Valiev/almostontop
    vercel/zsh-theme
    vladmyr/dotfiles-plugin
    willghatch/zsh-saneopt
    wuotr/zsh-plugin-vscode
    xylous/alias-zsh
    z-shell/zsh-diff-so-fancy
    zdharma-continuum/fast-syntax-highlighting
    zdharma-continuum/history-search-multi-word
    zdharma-continuum/zbrowse
    zdharma-continuum/zsh-navigation-tools
    zdharma/fast-syntax-highlighting
    zpm-zsh/colorize
    zpm-zsh/dropbox
    zpm-zsh/figures
    zpm-zsh/pr-return
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-syntax-highlighting
    # zshzoo/cd-ls
)

$DEBUG_SHELL && typeset -g ZPLG_MOD_DEBUG=1

$DEBUG_SHELL && echo "\nlooking for zinit in $ZINIT_ROOT..."

if [[ ! -d $ZINIT_ROOT ]]; then
    $DEBUG_SHELL && echo "zinit not found ($ZINIT_ROOT), installing..."
    local zinit_url="https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh"
    echo n | \
        bash -c "$(curl --fail --show-error --silent --location $zinit_url)" \
        1>/dev/null

    start_zinit

    zinit self-update

    zinit snippet OMZL::git.zsh
    zinit snippet OMZP::git

    zinit ice from'gh-r' as'program'

    zinit_runner "echo" $zinit_plugins_off
    zinit_runner "debug" $zinit_plugins
    zinit_runner "turbo" $zinit_plugins_turbo
else
    chmod g-rwX $ZINIT_ROOT
    start_zinit
fi

zinit_runner "start" $zinit_plugins
zinit_runner "start" $zinit_plugins_turbo
