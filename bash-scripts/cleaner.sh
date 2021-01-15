#!/usr/bin/zsh
source ~/.zshrc

setopt +o nomatch &&
    /bin/rm -rf $USER_TMP/git-clone/* &&
    /bin/rm -rf $USER_TMP/git-update/* &&
    /bin/rm -rf $USER_TMP/cron/dropbox/* &&
    /bin/rm -rf $USER_TMP/cron/keep-mic-muted/*
