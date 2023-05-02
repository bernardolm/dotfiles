function which_shell() {
    ps -p $$ -ocomm=
}

function contains_in_array() {
    # use like: contains_in_array $MY_ITEM "${MY_ARRAY[@]}"
    local my_pattern='^'$1'$'
    shift
    local my_array=("$@")
    printf '%s\n' "${my_array[@]}" | grep -P ${my_pattern} | wc -l | bc
}

function find_to_array() {
    eval "find $@ -print0" | while IFS= read -r -d '' file; do
        printf '%s\n' "$file"
    done
}

function items_counter() {
    [ "$1" = "" ] && echo 0 || echo `echo $1 | wc -l | bc`
}

function find_text_here() {
    rg -i $1 2> /dev/null
}

function find_function_by_name() {
    echo "searching functions or aliases with term: $1"
    print -rl -- ${(k)aliases} ${(k)functions} ${(k)parameters} | grep $1
}

function file_size() {
    command ls -lh $1 | cut -d' ' -f 5
}

function memory_used() {
	m=$(smem -H -c "name pss" -t -P "$1$" -n -k | tail -n 1 | sed -e 's/^[[:space:]]*//')
    echo "$1 is using ${m}of mem"
}

function memory_used_watcher() {
	watch -c -n1 -x bash -c "source $DOTFILES/zsh/memory_used.zsh; memory_used $1"
}

function kill_by_port() {
    sudo kill -9 $(sudo lsof -t -i:$1)
}

function is_number() {
    local num=$1
    local rg="^[+\-]{0,1}[0-9]+$"
    (echo "${num//[^\-+0-9]/}" | grep -Eq $rg) \
        && echo 1 \
        || echo 0
}

function files_count() {
    find "$1" -type f 2> /dev/null | wc -l | bc
}

function ls_2_exa() {
    args="$@"
    args=$(echo $args | sed 's/A/a/g')
    eval "exa $args"
}

function file_lines_2_inline() {
    /bin/cat < $1 | grep -v '#' | paste -sd' '
}
