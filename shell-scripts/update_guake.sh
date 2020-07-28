function update_guake () {
    git --git-dir $WORKSPACE_USER/guake/.git checkout .
    git --git-dir $WORKSPACE_USER/guake/.git checkout master
    make --directory $WORKSPACE_USER/guake reinstall
}
