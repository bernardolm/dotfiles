local functions_paths=("$DOTFILES/shell" "$SYNC_PATH/shell")

for fp in $functions_paths; do
    $DEBUG_SHELL && echo "\t\t🔎 searching function script files in $fp"

    for NAME in $(find $fp/*.sh); do
        [[ "$(basename $NAME)" == "functions.sh" ]] && continue

        if [ `/bin/cat $NAME | head -1 | grep -c '#!'` -gt 0 ]; then
            $DEBUG_SHELL && echo "\t\t\t⏭  hashbang found on $(basename $NAME), skipping..."
            continue
        fi

        $DEBUG_SHELL && echo "\t\t\t📄 loading function script `basename $NAME`"
        source $NAME
    done
done
