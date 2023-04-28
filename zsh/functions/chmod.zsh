function chmod_easy() {
    chmod u=$1,g=$2,o=$3 $4
}

function chmod_reset() {
    [ -z "$1" ] && echo "path is required" && return 1 || echo "resetting permissions on $1"
    sudo chown -R $USER:$USER "$1"
    sudo chmod -R 644 "$1"
    sudo chmod -R -x+X "$1"
    find "$1" -name "*.sh" -exec sudo chmod +x {} \;
    find "$1" -name "*.py" -exec sudo chmod +x {} \;
    find "$1" -name "*.zsh" -exec sudo chmod +x {} \;
    find "$1" -name "*.AppImage" -exec sudo chmod +x {} \;
    test -d "$1/bin" && find "$1/bin" -type f -exec sudo chmod +x {} \;
}
