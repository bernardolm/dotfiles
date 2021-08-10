function last_backup_version() {
    local 'module'
    local 'path'
    local 'file'
    local 'file_fallback'

    module=$1
    [ -z "$module" ] && echo "you needs to specify a module to retrieve last backup version" && return

    path=$SYNC_PATH/$module
    [ ! -d "$path" ] && echo "'$path' isn't a valid module path to retrieve last backup version" && return

    file="$path/${hostname}_current.txt"

    if [ -f "$file" ]; then
        echo $file
    fi

    file=$path/$(/bin/ls $path | /bin/grep current | /bin/head -n1)

    if [ -f "$file" ]; then
        echo $file
    fi

    return 1
}
