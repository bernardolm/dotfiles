local functions_paths=("$DOTFILES/shell" "$SYNC_PATH/shell")

for fp in $functions_paths; do
    $DEBUG_SHELL && echo "\t🔎 searching function script files in $fp"

    for NAME in $(find $fp/*.sh); do
        [[ "$(basename $NAME)" == "functions.sh" ]] && continue
        $DEBUG_SHELL && echo "\t\t📄 loading function script `basename $NAME`"
        source $NAME
    done
done
