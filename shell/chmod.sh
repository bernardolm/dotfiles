function chmod_easy() {
    chmod u=$1,g=$2,o=$3 $4
}

function chmod_reset() {
    [ -z $1 ] && echo "path is required" && return 1 || echo "resetting permissions on $1"
    sudo chown -R $USER:$USER $1
    sudo chmod -R 644 $1
    sudo chmod -R -x+X $1
    sudo chmod -R +x $1/**/*.sh
}
