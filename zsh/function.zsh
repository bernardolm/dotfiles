function has_hash_bang() {
    local file=$1
    [ `/bin/cat $file | head -2 | grep -c '#!'` -gt 0 ] && echo 1 || echo 0
}

source $DOTFILES/zsh/types.zsh

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
            shift
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
                shift
                continue
            fi

            if [ $script_base = "functions.sh" ]; then
                $DEBUG_SHELL && echo "💢 skipped."
                shift
                continue
            fi

            if [ `has_hash_bang $script_path` -eq 1 ]; then
                $DEBUG_SHELL && echo "#️⃣  skipped, hash bang found."
                shift
                continue
            fi

            source $script_path

            $DEBUG_SHELL && echo "✅ loaded."
        else
            $DEBUG_SHELL && echo -n "📁"

            local script_folder=$(basename "$script_path")

            $DEBUG_SHELL && echo ""

            for sp in `ls $script_path`; do
                load_script_path $space "$script_path/$sp"
            done
        fi

        shift
    done
}


# BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# fpath=(~/myfuncs $fpath)
# autoload myfunc1 myfunc2 ...
# https://zsh.sourceforge.io/Doc/Release/Functions.html

#add each topic folder to fpath so that they can add functions and completion scripts
# for topic_folder ($ZSH/*) if [ -d $topic_folder ]; then  fpath=($topic_folder $fpath); fi;
# https://github.com/anishathalye/dotbot
# https://dotfiles.github.io/tutorials/
# https://www.abdullah.today/encrypted-dotfiles/
