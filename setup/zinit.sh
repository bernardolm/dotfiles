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
    source_and_log_session $ZINIT_ROOT/zinit.git/zinit.zsh
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit
}

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

    # zinit ice from'gh-r' as'program'

    zinit_runner echo $(cat $DOTFILES/zinit/plugins.txt | grep '#')
    zinit_runner debug $(cat $DOTFILES/zinit/plugins.txt | grep -v '#')
    zinit_runner turbo $(cat $DOTFILES/zinit/plugins_turbo.txt | grep -v '#')
else
    chmod g-rwX $ZINIT_ROOT
    start_zinit
fi

zinit_runner start $(cat $DOTFILES/zinit/plugins.txt | grep -v '#')
zinit_runner turbo $(cat $DOTFILES/zinit/plugins_turbo.txt | grep -v '#')
