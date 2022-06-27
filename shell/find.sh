function find_to_array() {
    eval "find $@ -print0" | while IFS= read -r -d '' file; do
        printf '%s\n' "$file"
    done
}

local function items_counter() {
    [ "$1" = "" ] && echo 0 || echo `echo $1 | wc -l | bc`
}
