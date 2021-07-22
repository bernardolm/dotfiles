function restore_symbolic_links() {
    NOW=$(date +"%Y%m%d%H%M%S")

    while read line; do
        function ln_smart() {
            from=$1
            to=$2
            skipBackup=$3

            if [[ "$to" == "/home"* ]]; then
                [ ! $skipBackup ] && echo -n "backuping... " && mv $to "$to-bkp-$NOW"
                echo -n "linking $from to $to... "
                ln -sf $from $to
            else
                [ ! $skipBackup ] && echo -n "backuping with sudo... " && sudo mv $to "$to-bkp-$NOW"
                echo -n "linking with sudo $from to $to... "
                sudo ln -sf $from $to
            fi

            echo -ne "finish\n"
        }

        IFS=';' read -r -a paths <<< "$line"
        from=${paths[0]}
        to=${paths[1]}

        echo -n "checking $to... "

        if test -L $to; then
            echo -ne "is a symlink, skipping\n"
        elif test -d $to; then
            if test -L $to; then
                echo -ne "is a symlink to a directory\n"
            else
                echo -n "is a plain directory... "
                ln_smart $from $to
            fi
        elif test -f $to; then
            if test -L $to; then
                echo -ne "is a symlink to a file\n"
            else
                echo -n "is a plain file... "
                ln_smart $from $to
            fi
        else
            echo -n "don't exist... "
            ln_smart $from $to true
        fi
    done < $SYNC_PATH/symbolic-links/current.txt
}
