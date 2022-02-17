function last_backup_version() {
    local 'module'
    local 'path'
    local 'file'

    module=$1
    [ -z "$module" ] && echo "you needs to specify a module to retrieve last backup version" && return

    ext=$2
    [ -z "$ext" ] && echo "you needs to specify a extension to retrieve last backup version" && return

    path=$SYNC_PATH/$module
    [ ! -d "$path" ] && echo "'$path' isn't a valid module path to retrieve last backup version" && return

    file="$path/${hostname}_current.${ext}"
    [ -f "$file" ] && echo $file && return

    file=$path/$(/bin/ls $path | /bin/grep current | /bin/head -n1)
    [ -f "$file" ] && echo $file && return

    file="$path/current.${ext}"
    [ -f "$file" ] && echo $file && return
}
