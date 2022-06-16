#!/bin/zsh

source ~/.zshrc

reset

local function filter() {
    find $1 $2 -type f -name '.zsh_history*' -size $3 -print 2>/dev/null
}

local function remove() {
    $DEBUG_SHELL && echo "removing $@" && return

    /bin/rm $1
}

local function batch_filename() {
    echo "$HOME/zsh_history/.zsh_history_$(date +"%Y%m%d%H%M%S%N").txt"
}

local function merge() {
    $DEBUG_SHELL && echo "merging $@" && return

    local file=$1
    local new_file=$2
    [ ! -f $new_file ] && touch $new_file
    local batch_lines=`/bin/cat --squeeze-blank $new_file | wc -l`
    local lines=`/bin/cat --squeeze-blank $file | wc -l`
    /bin/cat --squeeze-blank $file >> $new_file
    local batch_lines_now=`/bin/cat --squeeze-blank $new_file | wc -l`
    [ $batch_lines_now -ge $(($batch_lines+$lines)) ] && remove $file
}

local function split_it() {
    $DEBUG_SHELL && echo "spliting $@" && return

    local file=$1
    local suffix="$HOME/zsh_history/.zsh_history_$(date +"%Y%m%d%H%M%S")_"
    split --additional-suffix '.txt' --bytes 20M -d --elide-empty-files --unbuffered $file $suffix
    [ -f $file ] && remove $file
}

local function doit() {
    $DEBUG_SHELL && echo "doing it $@"

    local size=$1
    local fn=$2
    local limit=$3
    local new_file=`batch_filename`
    local pipe_flow=$(filter $path_to_run "" $size)
    local total_files=`echo $pipe_flow | wc -l`

    echo -n "📂 $total_files file(s) found with $size"
    [ $total_files -eq 0 ] && echo "" && return

    pipe_flow=($(echo -n $pipe_flow))
    [ ${#pipe_flow[@]} -eq 0 ] && echo "" && return

    [ "$limit" = "" ] && limit=${#pipe_flow[@]}
    echo -n ", ${#pipe_flow[@]} item(s) found"
    [ "$limit" != "" ] && echo ", doing it up to $limit" || echo ""

    local i=0
    for f in "${pipe_flow[@]}"; do
        $DEBUG_SHELL && echo "$i -ge $limit?"
        if [ $i -ge $limit ]; then
            $DEBUG_SHELL && echo "calling doit again with $@"
            doit $@
        else
            $DEBUG_SHELL && echo "fn=$fn"
            case "$fn" in
                "remove") eval "$fn $f" ;;
                "merge") eval "$fn $f $new_file" ;;
                "split_it") eval "$fn $f" ;;
                *) echo "$fn? 🤔" ;;
            esac
        fi
        ((i=$i+1))
        # $DEBUG_SHELL || progress_bar $i $limit
    done
}

local path_to_run=$HOME

# smallest files to bin
# doit "-1k" "remove"

# merge not so small files
# for n in $(seq 1 5); do doit "-${n}M" "merge" "$((1000/${n}))"; done
# for n in $(seq 6 10); do doit "+$(($n-1))M -size -${n}M" "merge" "$((500/${n}))"; done
# for n in $(seq 11 15); do doit "+$(($n-1))M -size -${n}M" "merge" "$((250/${n}))"; done
# for n in $(seq 16 20); do doit "+$(($n-1))M -size -${n}M" "merge" "$((175/${n}))"; done

# split biggest files
doit "+20M" "split_it"
