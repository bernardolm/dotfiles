# foobar(){ dst="$HOME/zsh_history/$(date +'%Y%m%d%H%M')" ; mkdir -p $dst ; mv -v "$1" "$dst" ; }; export -f foobar; find ~ -mindepth 1 -maxdepth 1 -type f -name '*zsh_history*' | xargs -I {} bash -c 'foobar "$@"' _ {}; find ~/zsh_history/ -mindepth 1 -maxdepth 1 -name '*zsh_history*' | xargs -I {} bash -c 'foobar "$@"' _ {}


function zsh_history_sanitize() {
    local function new_histfile_name() {
        local name="$HOME/zsh_history/"
        name+=`basename -a $HISTFILE`
        name+="_NEW_"
        name+=$now
        echo -n $name
    }

    local function copy_histfile() {
        local new=$1
        cp $HISTFILE $new
    }

    local function search_files() {
        local search_in=$1
        local size_to_search=$2
        find $search_in -type f -size $size_to_search -regex '.*\.zsh_history[ \._]+.*' \
            -not -name $HISTFILE \
            -not -name `new_histfile_name` \
            2>/dev/null
    }

    local function count_lines() {
        local file="$1"
        /bin/cat --squeeze-blank $file | wc -l | bc
    }

    local function count_files() {
        local files="$1"
        echo -n $files | wc -l | bc
    }

    local function clean_file() {
        local file="$1"
        /bin/sed -i '/\x0/d' $file
        /bin/sed -i '/^[^:]/d' $file
    }

    local function zsh_history_clear() {
        local file="$1"
        local cmd="zsh-history-clear --file \"$file\" $($DEBUG_SHEL && echo --debug true)"
        $DEBUG_SHELL && echo "running: $cmd" && eval "$cmd" && return
	 eval $cmd 1>/dev/null
    }

    msg_start "zsh history sanitize$($DEBUG_SHELL && echo ' in '${RED}debug mode${NC})"

    local now=$(date +"%Y%m%d%H%M%S%N")

    local new_histfile=`new_histfile_name`
    copy_histfile $new_histfile
    clean_file $new_histfile

    echo -n "using history file $new_histfile"
    local histfile_lines=`count_lines $new_histfile`
    [ $histfile_lines -eq 0 ] && echo ", no lines found." && return
    echo ", $histfile_lines lines found."

    local current=0

    local search_in=`[ "$1" != "" ] && echo $1 || echo $HOME`
    local size_to_search=`[ "$2" != "" ] && echo $2 || echo "-100M"`

    echo -n "searching files in $search_in with $size_to_search"

    local files=`search_files $search_in $size_to_search`
    local total_files_to_sanitize=`count_files $files`

    [ $total_files_to_sanitize -eq 0 ] && echo ", no files found." && return

    echo ", merging $total_files_to_sanitize files"

    echo -n $files | while read filename; do
        $DEBUG_SHELL && echo -n "🔹 $filename"

        local filename_lines=`count_lines $filename`
        [ $filename_lines -eq 0 ] \
            && ($DEBUG_SHELL && echo ", no lines found." && continue) \
            || $DEBUG_SHELL && echo -n ", $filename_lines lines found."

        if [ $filename_lines -gt 0 ]; then
            $DEBUG_SHELL && echo -n " cleaning"
            clean_file $filename

            filename_lines=`count_lines $filename`
            [ $filename_lines -eq 0 ] \
                && ($DEBUG_SHELL && echo ", no lines found." && continue) \
                || $DEBUG_SHELL && echo -n ", $filename_lines lines found."

            local histfile_lines=`count_lines $new_histfile`
            $DEBUG_SHELL && echo -n " $histfile_lines lines now in histfile, merging"

            /bin/cat --squeeze-blank $filename | tee --append $new_histfile 1>/dev/null

            local histfile_final_lines=`count_lines $new_histfile`
            $DEBUG_SHELL && echo ", $histfile_final_lines at final."
        fi
        [ $histfile_final_lines -ge $(($histfile_lines+$filename_lines)) ] \
            && local remove_cmd="gio trash $($DEBUG_SHELL && echo -v || echo '') \"$filename\"" \
            && ($DEBUG_SHELL && echo "running: $remove_cmd" || true) \
            && eval "$remove_cmd"

        $DEBUG_SHELL && echo "increase history file to "`get_file_size $new_histfile`

        if [ $histfile_final_lines -ge 100000 ]; then
            zsh_history_clear $new_histfile
        fi

        let "current=$current+1"
        $DEBUG_SHELL || progress_bar $current $total_files_to_sanitize
    done
    zsh_history_clear $new_histfile
    # backup_it $new_histfile
    msg_end "finish file with size "`get_file_size $new_histfile`
}

function zsh_history_joiner() {
    local function filter() {
        find $1 $2 -type f -name '.zsh_history*' -size $3 -not -name $HISTFILE -print 2>/dev/null
    }

    local function remove() {
        $DEBUG_SHELL && echo "removing $@" && return
        gio trash $1
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
        local total_files=`echo -n $pipe_flow | wc -l`

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
    doit "-100M" "merge"

    # split biggest files
    doit "+100M" "split_it"
}
