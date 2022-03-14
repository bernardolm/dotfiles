function chmod_easy() {
    chmod u=$1,g=$2,o=$3 $4
}


function chmod_reset() {
    chmod -R $((777 - `umask`)) .
    chmod -R -x+X .
}
