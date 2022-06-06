function last_backup_version() {
    local module=$1
    local path=$SYNC_PATH/$module
    local ext=$2
    local file=$path/${hostname}_current.${ext}

    [ -z "$module" ] && echo "you needs to specify a module to retrieve last backup version" && return
    [ -z "$ext" ] && echo "you needs to specify a extension to retrieve last backup version" && return
    [ ! -d "$path" ] && echo "'$path' isn't a valid module path to retrieve last backup version" && return

    [ -f "$file" ] && echo $file && return

    file=$path/$(/bin/ls $path | /bin/grep -E ^current | /bin/head -n1)
    [ -f "$file" ] && echo $file && return

    file=$(/bin/find $path -type f | /bin/grep -E '.*20[0-9]{12}.*' | /bin/sort -r | /bin/head -n1)
    [ -f "$file" ] && echo $file && return
}
