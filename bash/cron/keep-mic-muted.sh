#!/usr/bin/env bash

function keep_mic_muted() {
    [ ! -z $1 ] && echo "duration param is $1";
    [ ! -z $2 ] && echo "times param is $2";
    [ -z $1 ] && echo "duration is required";
    [ -z $2 ] && times=$(($1/5)) || times=$(($2-1));
    [ $times -eq 0 ] && echo "finish" && exit 0;

    echo "repeating every 5s for $times times up to $1s";

    mic_muted
    sleep 5

    echo ""

    keep_mic_muted $1 $times
}

log_path=~/tmp/keep_mic_muted
[ ! -d $log_path ] && mkdir -p $log_path

keep_mic_muted 60 > $log_path/$(date +"%Y%m%d%H%M%S").log 2>&1
