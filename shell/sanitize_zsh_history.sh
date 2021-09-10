function sanitize_zsh_history() {
    find $SYNC_PATH -mindepth 1 -maxdepth 1 -name '.zsh_history *' | while read filename; do
        echo -n "🔹 $filename "
        tee -a $HISTFILE < $filename >/dev/null
        echo -n "increase history file to "`get_file_size $HISTFILE`"\n"
        /bin/rm "$filename"
        [ `stat -c '%s' $HISTFILE` -ge 50000000 ] && zsh-history-clear --file $HISTFILE
    done
    zsh-history-clear --file $HISTFILE
    echo "🏁 finish file with size "`get_file_size $HISTFILE`
}
