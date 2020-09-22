#!/bin/bash

function dropbox_schedule() {
    echo -e "running dropbox..."
    dropbox start >/dev/null
    echo -e "giving 5m to dropbox work..."
    sleep 5m
    echo -e "stopping dropbox..."
    dropbox stop
}

dropbox_schedule | tee /var/log/dropbox_schedule/$(date +"%Y-%m-%d-%H-%M").log
