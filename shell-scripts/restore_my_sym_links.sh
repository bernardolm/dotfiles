function restore_my_sym_links() {
    echo -e "restoring my symbolic links"

    TIMENOW=$(date +"%Y%m%d%H%M%S")

    while read i; do
        from=$(echo $i | cut -f1 -d\;)
        to=$(echo $i | cut -f2 -d\;)

        # TODO: ask for overwrite, backup or skip

        if [ -e $to ]; then
            echo "moving $to to $to-bkp-$TIMENOW"
            mv "$to" "$to-bkp-$TIMENOW"
        fi

        echo "linking $from -> $to"
        ln -s "$from" "$to"

        echo ""

    done <$SYNC_PATH/scripts/my-sym-links.txt
}
