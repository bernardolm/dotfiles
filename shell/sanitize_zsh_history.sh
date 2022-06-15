function sanitize_zsh_history() {
    echo "history file is $HISTFILE"
    local histfile_lines=`/bin/cat $HISTFILE | wc -l`
    $DEBUG_SHELL && echo "$histfile_lines lines in $HISTFILE at begin"

    local function list_files() {
        find -L ~ -mindepth 1 -maxdepth 1 -regex '.*\.zsh_history[ \._]+.*'
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

    msg_start "merging of $total files"

    echo $files | while read filename; do
        current=`count_current`
        declare -i diff=$total-$current
        $DEBUG_SHELL && echo "reduce from $last to $current ($diff/$total) files"
        last=$current
        $DEBUG_SHELL || progress_bar $diff $total

        $DEBUG_SHELL && echo "🔹 $filename "

        local filename_lines=`/bin/cat $filename | wc -l`
        $DEBUG_SHELL && echo "$filename_lines lines in $filename"
        if [ $filename_lines -gt 0 ]; then
            /bin/sed -i '/^\:/d' "$filename"
            
            local filename_lines=`/bin/cat $filename | wc -l`
            $DEBUG_SHELL && echo "$filename_lines lines in $filename after cleaning"
            
            [ $filename_lines -le 0 ] && continue

            local histfile_lines=`/bin/cat $HISTFILE | wc -l`
            $DEBUG_SHELL && echo "$histfile_lines lines in $HISTFILE"

            /bin/cat $filename | tee -a $HISTFILE 1>/dev/null
            
            local histfile_lines=`/bin/cat $HISTFILE | wc -l`
            $DEBUG_SHELL && echo "$histfile_lines lines in $HISTFILE at final"
        fi
        /bin/rm "$filename"

        [ $x -lt 25 ] && let "x=x+1" && continue
        let "x=0"

        $DEBUG_SHELL && echo "increase history file to "`get_file_size $HISTFILE`" size"

        [ `stat -c '%s' $HISTFILE` -ge 10000000 ] && zsh-history-clear --file $HISTFILE
    done
    zsh-history-clear --file $HISTFILE
    # backup_it $HISTFILE
    msg_end "🏁 finish file with size "`get_file_size $HISTFILE`
}
