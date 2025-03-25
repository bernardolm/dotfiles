log debug "checking zsh_history"

zsh_history_source=${HOME}/sync/home/.zsh_history
zsh_history_target=${HOME}/.zsh_history

function zsh_history_merge() {
    [ "$1" = "${zsh_history_source}" ] && return
    cat "$1" >> "${zsh_history_source}"
    /bin/rm -f "$1"

    lines_after=$(wc -l "${zsh_history_source}" | awk '{print $1}')
    log debug "'$1' merged into .zsh_history (${lines_after} lines)"
}

function zsh_history_uniq() {
    cat "${zsh_history_source}" | sort | uniq >> "${zsh_history_source}.new"
    /bin/rm -f "${zsh_history_source}"
    mv -f "${zsh_history_source}.new" "${zsh_history_source}"

    lines_after=$(wc -l "${zsh_history_source}" | awk '{print $1}')
    log info "zsh history uniq done (${lines_after} lines)"
}

if [ ! -f "${zsh_history_source}" ]; then
    touch "${zsh_history_source}"
    log info "${zsh_history_source} created"
fi

lines=$(wc -l "${zsh_history_source}" | awk '{print $1}')
log debug "lines in zsh history: $lines"

for f in "${zsh_history_source}"*; do
    zsh_history_merge "$f"
; done

if [ -f ${zsh_history_target} ] && [ ! -h "${zsh_history_target}" ]; then
    zsh_history_merge "${zsh_history_target}"
fi

lines_after=$(wc -l "${zsh_history_source}" | awk '{print $1}')
if [ $lines -ne $lines_after ]; then
    zsh_history_uniq
fi

if [ ! -h "${zsh_history_target}" ]; then
    ln -sf "${zsh_history_source}" "${zsh_history_target}"
    log info "zsh history (sym) linked"
fi
