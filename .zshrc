function sanitize_first_step() {
    cat | grep -v 'dotfiles/antigen' | sort
}

function sanitize_second_step() {
    cat | sanitize_first_step | grep -v 'dotfiles/zsh/init' | sort
}

function iterate_and_load() {
    local msg=$1
    local find_path=$2
    local find_term=$3
    local filter_fn=$4

    $DEBUG_SHELL && _starting ${msg}
    find "${find_path}" -name "${find_term}" | $filter_fn | while read -r file; do
        $DEBUG_SHELL && _debug "source ${file}"
        source "${file}"
    done
    $DEBUG_SHELL && _finishing ${msg}
}

export DOTFILES="$HOME/workspaces/bernardolm/dotfiles"

source $DOTFILES/zsh/init/10_debug.zsh

iterate_and_load "dotfiles init zsh's" \
    "$DOTFILES/zsh/init" "*.zsh" "sanitize_first_step"
iterate_and_load "sync path init zsh's" \
    "$SYNC_PATH/zsh/init" "*.zsh" "sanitize_first_step"
iterate_and_load "dotfiles zsh's" \
    "$DOTFILES" "*.zsh" "sanitize_second_step"
iterate_and_load "sync path aliases" \
    "$DOTFILES" "aliases" "sanitize_second_step"

local hudctl_completion='/usr/local/lib'
hudctl_completion+='/node_modules/hudctl/completion'
hudctl_completion+='/hudctl-completion.bash'
[ -f ${hudctl_completion} ] && source ${hudctl_completion}

command -v disable_accelerometter &>/dev/null && disable_accelerometter
