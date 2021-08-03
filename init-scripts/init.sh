export TERM=xterm-256color # for common 256 color terminals (e.g. gnome-terminal)
export USER_TMP=$HOME/tmp

[ -d $HOME/Sync/config-backup ] && export SYNC_PATH=$HOME/Sync/config-backup
[ -d $SYNC_PATH/bin ] && export PATH=$PATH:$SYNC_PATH/bin:

# Workspaces (at this point, isn't exist workspaces envs exported)
export GITHUB_USER=$(git config github.user)
export GITHUB_ORG=$(git config github.organization)
source $HOME/workspaces/$GITHUB_USER/first-steps-ubuntu/init-scripts/workspace.sh

# Loading init scripts
INIT_PATHS=(
    $SYNC_PATH/scripts/init-scripts
    $WORKSPACE_USER/first-steps-ubuntu/init-scripts
)

$DEBUG && echo "💿 loading init scripts in paths $INIT_PATHS"

for P in $INIT_PATHS; do
    $DEBUG && echo "📁 loading path $P"
    if [ ! -d "$P" ]; then
        $DEBUG && echo "\t📄 loading script `basename $P`"
        source $p
    else
        $DEBUG && echo "\t🔎 searching scripts in path `basename $P`"
        for SP in $(find $P/*.sh ! -name '*init.sh'); do
            $DEBUG && echo "\t\t📄 loading script `basename $SP`"
            source $SP
        done
    fi
done
