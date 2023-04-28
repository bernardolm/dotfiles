function hudctl() {
    CMD=$(echo $@ | cut -c4-)
    case $* in
        cd* ) cd $(hudctl path "$CMD");;
        * ) command hudctl "$@";;
    esac;
}
