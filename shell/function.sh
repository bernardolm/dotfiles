function has_hash_bang() {
    local file=$1
    [ `/bin/cat $file | head -2 | grep -c '#!'` -gt 0 ] && echo 1 || echo 0
}

source $DOTFILES/shell/types.sh

function load_script_path() {
    local function spacer() {
        local output=""
        for ((n=1;n<=$1;n++)); do
            output="$output    "
        done
        echo $output
    }

    local space=0

    while test $# -gt 0
    do
        if [ `is_number $1` -eq 1 ]; then
            ((space=$1+1))
            shift 1
            continue
        fi

        local script_path=$1
        local script_base=$(basename "$script_path")

        $DEBUG_SHELL && echo -n "$(spacer $space)checking $script_path 🔍"

        if [ -f $script_path ]; then
            $DEBUG_SHELL && echo -n "📄"

            local script_file_ext="${script_base##*.}"
            local script_file_name="${script_base%.*}"

            if [ "$script_file_ext" != "sh" -a "$script_file_name" != "aliases" ]; then
                $DEBUG_SHELL && echo "💢, not a script, skipped."
                shift 1
                continue
            fi

            if [ $script_base = "functions.sh" ]; then
                $DEBUG_SHELL && echo "💢 skipped."
                shift 1
                continue
            fi

            if [ `has_hash_bang $script_path` -eq 1 ]; then
                $DEBUG_SHELL && echo "#️⃣  skipped, hash bang found."
                shift 1
                continue
            fi

            source $script_path
            $DEBUG_SHELL && echo "✅ loaded."
        else
            echo -n "📁"

            local script_folder=$(basename "$script_path")

            if [ "$script_folder" = "init" ]; then
                $DEBUG_SHELL && echo "✔ already loaded."
                shift 1
                continue
            else
                $DEBUG_SHELL && echo ""
            fi

            for sp in `ls $script_path`; do
                load_script_path $space "$script_path/$sp"
            done
        fi

        shift 1
    done
}
