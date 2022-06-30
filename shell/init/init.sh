# Loading init scripts
local init_scripts_path=(
    $SYNC_PATH/shell/init
    $DOTFILES/shell/init
)

$DEBUG_SHELL && echo "💿 loading init scripts in paths $init_scripts_path"

local function load_custom_script() {
    local script=$1
    local tabs=$2
    local script_file=`basename $script`

    $DEBUG_SHELL && echo -n "${tabs}📄 checking $script_file..."

    [ $script_file = "functions.sh" ] && echo ""

    if [ `/bin/cat $script | head -1 | grep -c '#!'` -gt 0 ]; then
        $DEBUG_SHELL && echo " hashbang found on $script_file, skipping..."
        return
    fi

    if [[ ! "($INIT_SCRIPTS)" =~ "$script_file" ]]; then
        source $script
        $DEBUG_SHELL && [[ "$script_file" != "functions.sh" ]] \
            && echo " loaded."
    else
        $DEBUG_SHELL && echo " already loaded."
    fi
}

for scripts_path in $init_scripts_path; do
    $DEBUG_SHELL && echo "📁 loading path $scripts_path"

    if [ ! -d "$scripts_path" ]; then
        load_custom_script $scripts_path "\t"
    else
        $DEBUG_SHELL && echo "\t🔎 searching scripts in path `basename $scripts_path`"

        for another_scripts_path in $(find $scripts_path/*.sh); do
            load_custom_script $another_scripts_path "\t\t"
        done
    fi
done
