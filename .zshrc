sanitize_first_step() {
    cat | grep -v 'dotfiles/antigen' | grep -v 'antigen/antigen' | sort
}

sanitize_second_step() {
    cat | sanitize_first_step | grep -v '/zsh/init' | sort
}

iterate_and_load() {
    local msg=$1
    local find_path=$2
    local find_term=$3
    local filter_fn=$4

    $DEBUG_SHELL && _starting "${msg}"

    local cmd="find ${find_path} -name '${find_term}' -print | ${filter_fn}"
    $DEBUG_SHELL && _debug "${cmd}"

    eval "${cmd}" | while read -r script_file; do
        $DEBUG_SHELL && _debug "source '${script_file}'"
        source "${script_file}"
    done
    $DEBUG_SHELL && _finishing "${msg}"
}

eval source "$(find ~ -wholename '*zsh/init/10_debug.zsh' -print)" &>/dev/null
eval source "$(find ~ -wholename '*zsh/init/30_env.zsh' -print)" &>/dev/null

iterate_and_load "dotfiles init zsh's" \
    "$DOTFILES/zsh/init" "*.zsh" "sanitize_first_step"

iterate_and_load "dotfiles zsh's" \
    "$DOTFILES" "*.zsh" "sanitize_second_step"

iterate_and_load "dotfiles aliases" \
    "$DOTFILES" "aliases" "sanitize_second_step"

iterate_and_load "sync path init zsh's" \
    "$SYNC_DOTFILES/zsh/init" "*.zsh" "sanitize_first_step"

iterate_and_load "sync path zsh's" \
    "$SYNC_DOTFILES/*" "*.zsh" "sanitize_second_step"

iterate_and_load "sync path aliases" \
    "$SYNC_DOTFILES/*" "aliases" "sanitize_second_step"

hudctl_completion='/usr/local/lib'
hudctl_completion+='/node_modules/hudctl/completion'
hudctl_completion+='/hudctl-completion.bash'
[ -f ${hudctl_completion} ] && source "${hudctl_completion}"

command -v disable_accelerometter &>/dev/null && disable_accelerometter
