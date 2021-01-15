#!/bin/bash

setopt +o nomatch &&
    /bin/rm -rf ~/tmp/git-clone/* &&
    /bin/rm -rf ~/tmp/git-update/* &&
    /bin/rm -rf ~/tmp/cron/dropbox/* &&
    /bin/rm -rf ~/tmp/cron/keep-mic-muted/*
