[ -f $SYNC_PATH/aliases ] && \
    (($DEBUG && echo "loading sync path aliases") || true) && \
    source $SYNC_PATH/aliases
[ -f $WORKSPACE_USER/first-steps-ubuntu/aliases ] && \
    (($DEBUG && echo "loading git path aliases") || true) && \
    source $WORKSPACE_USER/first-steps-ubuntu/aliases
