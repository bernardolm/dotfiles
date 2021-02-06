function contains_in_array() {
    # use like: contains_in_array $MY_ITEM "${MY_ARRAY[@]}"
    local my_pattern='^'$1'$'
    shift
    local my_array=("$@")
    printf '%s\n' "${my_array[@]}" | grep -P ${my_pattern} | wc -l | bc
}
