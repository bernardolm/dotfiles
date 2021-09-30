# Loading init scripts
init_scripts_path=(
    $SYNC_PATH/shell/init
    $DOTFILES/shell/init
)

$DEBUG_SHELL && echo "💿 loading init scripts in paths $init_scripts_path"

for scripts_path in $init_scripts_path; do
    $DEBUG_SHELL && echo "📁 loading path $scripts_path"
    if [ ! -d "$scripts_path" ]; then
        $DEBUG_SHELL && echo "\t📄 loading script `basename $scripts_path`"
        source $scripts_path
    else
        $DEBUG_SHELL && echo "\t🔎 searching scripts in path `basename $scripts_path`"
        for another_scripts_path in $(find $scripts_path/*.sh ! -name '*init.sh'); do
            $DEBUG_SHELL && echo "\t\t📄 loading script `basename $another_scripts_path`"
            source $another_scripts_path
        done
    fi
done
