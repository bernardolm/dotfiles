FUNCTIONS_PATH="$(dirname $(readlink -f $0))/shell-scripts"
$DEBUG && echo -n "loading scripts from $FUNCTIONS_PATH\n"

for NAME in $(find $FUNCTIONS_PATH/*.sh); do
    source $NAME
done
