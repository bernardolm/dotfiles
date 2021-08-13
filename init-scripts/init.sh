export TERM=xterm-256color # for common 256 color terminals (e.g. gnome-terminal)
export USER_TMP=$HOME/tmp

[ -d $HOME/Sync/config-backup ] && export SYNC_PATH=$HOME/Sync/config-backup
[ -d $SYNC_PATH/bin ] && export PATH=$PATH:$SYNC_PATH/bin:

# Workspaces (at this point, isn't exist workspaces envs exported)
export GITHUB_USER=$(git config github.user)
export GITHUB_ORG=$(git config github.organization)
source $HOME/workspaces/$GITHUB_USER/first-steps-ubuntu/init-scripts/workspace.sh

# Loading init scripts
init_scripts_path=(
    $SYNC_PATH/scripts/init-scripts
    $WORKSPACE_USER/first-steps-ubuntu/init-scripts
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
