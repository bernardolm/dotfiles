FUNCTIONS_PATH="$(dirname $(readlink -f $0))"
$DEBUG_SHELL && echo -n "\t\t\t🔎 searching script files in $FUNCTIONS_PATH\n"

for NAME in $(find $FUNCTIONS_PATH/*.sh); do
    [[ "$(basename $NAME)" == "functions.sh" ]] && continue
    [[ "$(basename $NAME)" == "env.sh" ]] && continue
    $DEBUG_SHELL && echo "\t\t\t\t📄 loading script `basename $NAME`"
    source $NAME
done
