# Loading init scripts
init_scripts_path=(
    $SYNC_PATH/scripts/init-scripts
    $DOTFILES/init-scripts
)

$DEBUG && echo "💿 loading init scripts in paths $init_scripts_path"

for scripts_path in $init_scripts_path; do
    $DEBUG && echo "📁 loading path $scripts_path"
    if [ ! -d "$scripts_path" ]; then
        $DEBUG && echo "\t📄 loading script `basename $scripts_path`"
        source $scripts_path
    else
        $DEBUG && echo "\t🔎 searching scripts in path `basename $scripts_path`"
        for another_scripts_path in $(find $scripts_path/*.sh ! -name '*init.sh'); do
            $DEBUG && echo "\t\t📄 loading script `basename $another_scripts_path`"
            source $another_scripts_path
        done
    fi
done
