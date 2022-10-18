# Source ref.: https://unix.stackexchange.com/a/453170/279103
# Say the file, line number and optional message for debugging
# Inspired by bash's `caller` builtin
# Thanks to https://unix.stackexchange.com/a/453153/143394
function yelp () {
    # shellcheck disable=SC2154  # undeclared zsh variables in bash
    if [[ $BASH_VERSION ]]; then
        local file=${BASH_SOURCE[1]} func=${FUNCNAME[1]} line=${BASH_LINENO[0]}
    else  # zsh
        emulate -L zsh  # because we may be sourced by zsh `emulate bash -c`
        # $funcfiletrace has format:  file:line
        local file=${funcfiletrace[1]%:*} line=${funcfiletrace[1]##*:}
        local func=${funcstack[2]}
        [[ $func =~ / ]] && func=source  # $func may be filename. Use bash behaviour
    fi
    echo "${file##*/}:$func:$line $*" > /dev/tty
}
