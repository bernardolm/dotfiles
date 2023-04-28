function guake_update() {
    git --git-dir $WORKSPACE_USER/guake/.git checkout .
    git --git-dir $WORKSPACE_USER/guake/.git checkout master
    git --git-dir $WORKSPACE_USER/guake/.git pull origin master
    sudo make --directory $WORKSPACE_USER/guake uninstall
    make --directory $WORKSPACE_USER/guake
    sudo make --directory $WORKSPACE_USER/guake install
}
