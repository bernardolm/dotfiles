# foobar(){ dst="$HOME/zsh_history/$(date +'%Y%m%d%H%M')" ; mkdir -p $dst ; mv -v "$1" "$dst" ; }; export -f foobar; find ~ -mindepth 1 -maxdepth 1 -type f -name '*zsh_history*' | xargs -I {} bash -c 'foobar "$@"' _ {}; find ~/zsh_history/ -mindepth 1 -maxdepth 1 -name '*zsh_history*' | xargs -I {} bash -c 'foobar "$@"' _ {}


function sanitize_zsh_history() {
    backup_it $HISTFILE
    local new_histfile="$HOME/zsh_history/`basename -a $HISTFILE`_NEW_"$(date +"%Y%m%d%H%M%S%N")"
    cp $HISTFILE $new_histfile
    echo "history file is $new_histfile"
    local histfile_lines=`/bin/cat --squeeze-blank $new_histfile | wc -l`
    $DEBUG_SHELL && echo "$histfile_lines lines in $new_histfile at begin"

    local function list_files() {
        find -L $HOME -size -101M -regex '.*\.zsh_history[ \._]+.*' -not -name $HISTFILE -not -name $new_histfile 2>/dev/null
    }

    local function count_current() {
        [ -z $files ] && files=`list_files`
        list_files | wc -l
    }

    local current
    local files=`list_files`
    local last=`count_current`
    local total=$last
    local x=0
    local merge_up_to=3

    [ $total -eq 0 ] && msg_end "no files found and" && return

    msg_start "merging of $total files"

    echo $files | while read filename; do
        current=`count_current`
        declare -i diff=$total-$current
        $DEBUG_SHELL && echo "reduce from $last to $current ($diff/$total) files"
        last=$current
        $DEBUG_SHELL || progress_bar $diff $total

        $DEBUG_SHELL && echo "🔹 $filename "

        local filename_lines=`/bin/cat --squeeze-blank $filename | wc -l`
        $DEBUG_SHELL && echo "$filename_lines lines in $filename"
        if [ $filename_lines -gt 0 ]; then
            local cleaned="${filename}_clean"
            touch $cleaned
            /bin/sed '/\x0/d' "$filename" > $cleaned
            mv -f $cleaned "$filename"

            local filename_lines=`/bin/cat --squeeze-blank $filename | wc -l`
            $DEBUG_SHELL && echo "$filename_lines lines in $filename after cleaning"

            [ $filename_lines -le 0 ] && continue

            local histfile_lines=`/bin/cat --squeeze-blank $new_histfile | wc -l`
            $DEBUG_SHELL && echo "$histfile_lines lines in $new_histfile"

            /bin/cat --squeeze-blank $filename | tee -a $new_histfile 1>/dev/null

            local histfile_lines=`/bin/cat --squeeze-blank $new_histfile | wc -l`
            $DEBUG_SHELL && echo "$histfile_lines lines in $new_histfile at final"
        fi
        /bin/rm "$filename"

        #echo "x=$x, and up to $merge_up_to"
        [ $x -lt $merge_up_to ] && let "x=x+1" && continue
        let "x=0"

        $DEBUG_SHELL && echo "increase history file to "`get_file_size $new_histfile`" size"

        [ `stat -c '%s' $new_histfile` -ge 1000 ] && zsh-history-clear --file $new_histfile || true
    done
    zsh-history-clear --file $new_histfile
    backup_it $new_histfile
    msg_end "🏁 finish file with size "`get_file_size $new_histfile`
}

function zsh_history_joiner() {
    local function filter() {
        find $1 $2 -type f -name '.zsh_history*' -size $3 -not -name $HISTFILE -print 2>/dev/null
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
        local suffix="$HOME/zsh_history/.zsh_history_"$(date +"%Y%m%d%H%M%S")"_"
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
        [ "$limit" != "" ] && echo ", executing $fn up to $limit" || echo ""

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
            $DEBUG_SHELL || progress_bar $i $limit
        done
    }

    local path_to_run=$HOME

    # smallest files to bin
    doit "-1c" "remove"
    doit "-1w" "remove"

    # merge not so small files
    for n in $(seq 1 5); do doit "-${n}M" "merge" "$((1000/${n}))"; done
    for n in $(seq 6 10); do doit "+$(($n-1))M -size -${n}M" "merge" "$((500/${n}))"; done
    for n in $(seq 11 15); do doit "+$(($n-1))M -size -${n}M" "merge" "$((250/${n}))"; done
    for n in $(seq 16 20); do doit "+$(($n-1))M -size -${n}M" "merge" "$((175/${n}))"; done

    # split biggest files
    doit "+20M" "split_it"
}
