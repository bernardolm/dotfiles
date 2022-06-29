function chmod_easy() {
    chmod u=$1,g=$2,o=$3 $4
}

function chmod_reset() {
    [ -z "$1" ] && echo "path is required" && return 1 || echo "resetting permissions on $1"
    sudo chown -R $USER:$USER "$1"
    chmod -R 644 "$1"
    chmod -R -x+X "$1"
    find "$1" -name "*.sh" -exec chmod +x {} \;
}
