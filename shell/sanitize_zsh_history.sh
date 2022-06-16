function sanitize_zsh_history() {
    backup_it $HISTFILE
    local new_histfile="${HISTFILE}_NEW_$(date +"%Y%m%d%H%M%S%N")"
    cp $HISTFILE $new_histfile
    echo "history file is $new_histfile"
    local histfile_lines=`/bin/cat --squeeze-blank $new_histfile | wc -l`
    $DEBUG_SHELL && echo "$histfile_lines lines in $new_histfile at begin"

    local function list_files() {
        find -L $HOME -size -100M -regex '.*\.zsh_history[ \._]+.*' 2>/dev/null \
            | /bin/grep -v "$new_histfile"
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

        [ $x -lt 25 ] && let "x=x+1" && continue
        let "x=0"

        $DEBUG_SHELL && echo "increase history file to "`get_file_size $new_histfile`" size"

        [ `stat -c '%s' $new_histfile` -ge 1000 ] && zsh-history-clear --file $new_histfile || true
    done
    zsh-history-clear --file $new_histfile
    backup_it $new_histfile
    msg_end "🏁 finish file with size "`get_file_size $new_histfile`
}
