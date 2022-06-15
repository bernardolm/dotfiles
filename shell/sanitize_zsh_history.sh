function sanitize_zsh_history() {
    [ -f $SYNC_PATH/.zsh_history ] \
        && mv $SYNC_PATH/.zsh_history $SYNC_PATH/.zsh_history_$(date +"%Y%m%d%H%M%S") \
        || touch $SYNC_PATH/.zsh_history

    local function list_files() {
        find -L ~ -mindepth 1 -maxdepth 1 -regex '.*\.zsh_history[ \._]+.*'
    }

    local function count_current() {    
        # [ -z $files ] && files=`list_files`
        list_files | wc -l
    }

    local current
    local files=`list_files`
    local last=`count_current`
    local total=$last
    local x=0

    msg_start "merging $total files"

    echo $files | while read filename; do
        $DEBUG_SHELL && echo "🔹 $filename "

        /bin/sed -i '/^\:/d' $filename
        tee -a $HISTFILE < $filename &>/dev/null
        /bin/rm "$filename"

        [ $x -lt 25 ] && let "x=x+1" && continue
        let "x=0"

        current=`count_current`
        declare -i diff=$total-$current
        $DEBUG_SHELL && echo "reduce from $last to $current ($diff/$total) files"
        progress_bar $diff $total
        last=$current

        $DEBUG_SHELL && echo "increase history file to "`get_file_size $HISTFILE`" size"

        [ `stat -c '%s' $HISTFILE` -ge 10000000 ] && zsh-history-clear --file $HISTFILE
    done
    zsh-history-clear --file $HISTFILE
    # backup_it $SYNC_PATH/.zsh_history
    msg_end "🏁 finish file with size "`get_file_size $HISTFILE`
}
