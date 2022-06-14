FUNCTIONS_PATH="$(dirname $(readlink -f $0))"
$DEBUG_SHELL && echo "\t\t\t🔎 searching function script files in $FUNCTIONS_PATH"

for NAME in $(find $FUNCTIONS_PATH/*.sh); do
    [[ "$(basename $NAME)" == "functions.sh" ]] && continue
    $DEBUG_SHELL && echo "\t\t\t\t📄 loading function script `basename $NAME`"
    source $NAME
done
