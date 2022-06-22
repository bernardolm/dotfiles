function zsh_history_sanitize() {
    local function new_histfile_name() {
        local workdir=$1
        local name=$workdir
        name+="/`basename -a $HISTFILE`"
        name+="_NEW_"
        name+=$now
        echo -n $name
    }

    local function copy_histfile() {
        local new_histfile=$1
        cp $HISTFILE $new_histfile
    }

    local function search_files() {
        local workdir=$1
        local size_to_search=$2
        find $workdir -type f -size $size_to_search -regex '.*\.zsh_history[ \._]+.*' \
            -not -name \"$HISTFILE\" \
            -not -name \"`new_histfile_name $workdir`\" \
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
        local cmd="zsh-history-clear --file \"$file\" \
            `$DEBUG_SHELL && echo --debug true`"
        $DEBUG_SHELL && echo "running: $cmd" && return
        eval $cmd 1>/dev/null
    }

    local workdir=`([ "$1" != "" ] && echo $1) \
        || (echo "\n⚠️ you need to pass workdir" && return)`
    local size_to_search=`[ "$2" != "" ] && echo $2 \
        || echo "-100M"`
    local now=`date +"%Y%m%d%H%M%S%N"`

    echo_var workdir
    echo_var size_to_search
    echo_var now

    msg_start "zsh history sanitize in `$DEBUG_SHELL && echo ' with '${RED}debug mode${NC}`"

    return

    local new_histfile=`new_histfile_name $workdir`
    copy_histfile $new_histfile
    clean_file $new_histfile

    echo -n "using history file $new_histfile"
    local histfile_lines=`count_lines $new_histfile`
    [ $histfile_lines -eq 0 ] && echo ", no lines found." && return
    echo ", $histfile_lines lines found."

    local current=0



    echo -n "searching files in $workdir with $size_to_search"

    local files=`search_files "$workdir" "$size_to_search"`
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
        
        if [ $histfile_final_lines -ge $(($histfile_lines+$filename_lines)) ]; then
            local is_verbose=`$DEBUG_SHELL && echo "-v" || echo ""`
            local remove_cmd="trash-put $is_verbose $filename"
            $DEBUG_SHELL && echo "running: $remove_cmd" && return
            eval $remove_cmd
        fi

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

function zsh_history_divide() {
    local function filter() {
        local workdir=$1
        local size=$2
        local file_to_except=$3

        find $workdir -type f -name '*zsh_history*' -size $size \
            -not -name $HISTFILE \
            -not -name $file_to_except \
            -print 2>/dev/null
    }

    local function remove() {
        $DEBUG_SHELL && echo "removing $@" && return
        local file=$1
        eval "gio trash $file 1>/dev/null"
    }

    local function batch_filename() {
        local workdir="$1"
        local batch_path="$workdir/`hostname`/$now"
        /bin/mkdir -p $batch_path
        batch_path+="/zsh_history.txt"
        touch $batch_path
        echo $batch_path
    }

    local function merge() {
        $DEBUG_SHELL && echo "merging $@"
        local file=$1
        local new_file=$2

        local file_lines=`/bin/cat --squeeze-blank \
            $file | wc -l | bc`
        local new_file_lines=`/bin/cat --squeeze-blank \
            $new_file | wc -l | bc`
        
        /bin/cat --squeeze-blank $file >> $new_file
        
        local new_file_lines_now=`/bin/cat --squeeze-blank \
            $new_file | wc -l | bc`
        
        [ $new_file_lines_now -ge $(($new_file_lines+$file_lines)) ] \
            && remove $file \
            || tamanho_ta_errado
    }

    local function split_it() {
        $DEBUG_SHELL && echo "spliting $@" && return

        local workdir=$1
        local file=$2
        local size=`sed 's/[-+]//g' $3`
        local suffix="$1/`date +"%Y%m%d%H%M%S%N"`"
        mkdir -p $suffix 1>/dev/null
        suffix+="/zsh_history_`hostname`_"
        echo split --additional-suffix '.txt' --bytes $size -d --elide-empty-files --unbuffered $file $suffix
        # [ -f $file ] && remove $file
    }

    local function doit() {
        $DEBUG_SHELL && echo "doing it $@`$DEBUG_SHELL && echo ' in '${RED}debug mode${NC}`"

        local workdir=$1
        local size=$2
        local action=$3
        local limit=$4

        local new_file=`batch_filename $workdir`
        local files=`filter $workdir $size $new_file`
        local total_files=`echo -n $files | wc -l | bc`

        echo -n "🔎 $total_files file(s) found in $workdir with $size"
        [ $total_files -eq 0 ] && echo "" && return

        files=($(echo -n $files))
        [ ${#files[@]} -eq 0 ] && echo "" && return

        [ "$limit" = "" ] && limit=${#files[@]}
        echo -n ", ${#files[@]} item(s) found"
        [ "$limit" != "" ] && echo ", executing $action up to $limit" || echo ""

        local i=0
        for file in "${files[@]}"; do
            if [ $i -ge $limit ]; then
                $DEBUG_SHELL && echo "calling doit again with $@"
                doit $@
            else
                $DEBUG_SHELL && echo "calling $action"
                case "$action" in
                    "remove") eval "$action $file" ;;
                    "merge") eval "$action $file $new_file" ;;
                    "split_it") eval "$action $workdir $file" $size ;;
                    *) echo "$action? 🤔" ;;
                esac
            fi
            ((i=$i+1))
            $DEBUG_SHELL || progress_bar $i $limit $action
        done
    }

    local now=`date +"%Y%m%d%H%M%S%N"`
    local temp_workdir="$HOME/zsh_history"

    # merge not so small files
    doit "$temp_workdir" -100M merge

    # split biggest files
    doit "$temp_workdir" +100M split_it
}

function zsh_history_sanitize_express() {
    local now=`date +"%Y%m%d%H%M%S%N"`
    local temp_workdir="$HOME/zsh_history"
    local send_to_file="$temp_workdir/___zsh_history___$now"
    touch $send_to_file

    for s in $(seq 1 100); do
        local size="-${s}M"
        local cmd_find="find $temp_workdir -type f -size $size -not -name '`basename -a $send_to_file`'"
        for file in $(eval $cmd_find); do
            # clear
            echo "\n\n$cmd_find"
            echo "size ($size) - $file"
            echo -n "catting lines from $file"
            local file_content=`/bin/cat --squeeze-blank "$file"`
            local lines=`echo $file_content | wc -l | bc`
            echo " - $lines"
            if [ $lines -gt 0 ]; then
                echo -n "catting lines from $send_to_file"
                local destiny_lines=`/bin/cat --squeeze-blank "$send_to_file" | wc -l | bc`
                echo " - $destiny_lines"
                echo "sending lines from $file to $send_to_file"
                /bin/cat --squeeze-blank "$file_content" >> "$send_to_file"
                echo -n "catting lines again from $send_to_file"
                local new_destiny_lines=`/bin/cat --squeeze-blank "$send_to_file" | wc -l | bc`
                echo " - $new_destiny_lines"
            fi
            echo -n "removing $file"
            [ $new_destiny_lines -gt $destiny_lines ] && gio trash  "$file"
            echo ", remove called to $file"
            [ ! -f "$file" ] && echo "$file se foi"
            if [ $new_destiny_lines -gt 500000 ]; then
                echo -n "calling zsh-history-clear to $send_to_file"
                zsh-history-clear --file "$send_to_file"
                echo -n ", finished zsh-history-clear to $send_to_file"
                local final_destiny_lines=`/bin/cat --squeeze-blank "$send_to_file" | wc -l | bc`
                echo " - $final_destiny_lines"
                notify-send "zsh-history-clear" "`date +"%Y-%m-%d %Hh%M"`: $new_destiny_lines -> $final_destiny_lines"
            fi 
            # sleep 5
        done
    done
}
