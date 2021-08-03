[ -d ~/workspaces/$GITHUB_USER ] && export WORKSPACE_USER=~/workspaces/$GITHUB_USER
[ -d ~/workspaces/$GITHUB_ORG ] && export WORKSPACE_ORG=~/workspaces/$GITHUB_ORG

[ ! -d $WORKSPACE_USER ] && mkdir -p $WORKSPACE_USER
[ ! -d $WORKSPACE_ORG ] && mkdir -p $WORKSPACE_ORG
