function last_backup_version() {
    local ext="$2"
    local module="$1"
    local now=$(date +"%Y%m%d%H%M%S")
    local path="$SYNC_PATH/$module"
    local file="$path/${hostname}_${now}.${ext}"

    [ -z "$module" ] && echo "you needs to specify a module to retrieve last backup version" && return
    [ -z "$ext" ] && echo "you needs to specify a extension to retrieve last backup version" && return
    [ ! -d "$path" ] && echo "'$path' isn't a valid module path to retrieve last backup version" && return

    [ -f "$file" ] && echo "$file" && return

    local file_tmp="$path/$(/bin/ls "$path" | /bin/grep -E '^current' | /bin/head -n1)"
    [ -f "$file_tmp" ] && echo "$file_tmp" && return

    file_tmp=$(/bin/find "$path" -type f | /bin/grep -E ".*20[0-9]{12}.*" | /bin/sort -r | /bin/head -n1)
    [ -f "$file_tmp" ] && echo "$file_tmp" && return

    touch $file && echo "$file" && return
}
