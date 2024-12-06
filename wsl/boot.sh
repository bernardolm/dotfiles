#!/usr/bin/env bash

# Configuration
disk_uuid=D6623F1C623F00B3
elapsed=0
interval=2
timeout=10
username=bernardo
virtual_disk_path="C:/wsl/Ubuntu-24.04/ubuntu-home-64gb.vhd"

# Mount point
mount_point="/home/${username}"

# Attaching virtual disk to WSL
function attach_vhd_to_wsl() {
    cmd="/mnt/c/Users/${username}/AppData/Local/Microsoft/WindowsApps/wsl.exe -d $WSL_DISTRO_NAME --mount --vhd ${virtual_disk_path} --bare"
    echo "> ${cmd}"
    eval "${cmd} | echo already attached" 2>/dev/null
}

# get disk device path
function get_disk_path() {
    blkid --uuid ${disk_uuid}
}

function mount_home() {
    # Umounting exist mounting point
    cmd="umount ${mount_point}"
    echo "> ${cmd}"
    eval "${cmd}"

    cmd="mount -o defaults,permissions $(get_disk_path) ${mount_point}"
    echo "> ${cmd}"
    eval "${cmd}"

    # Showing mounted
    cmd="mount -l | grep ${mount_point}"
    echo "> ${cmd}"
    eval "${cmd}"
}

attach_vhd_to_wsl

mount_home

# Wait for the target drive to be ready
while [ "$(mount -l | grep -c ${mount_point})" -eq 0 ]; do
    if [ ${elapsed} -ge ${timeout} ]; then
        echo "Timed out waiting for ${mount_point} to be ready."
        exit 1
    fi

    echo "Waiting for ${mount_point} to be ready..."
    sleep ${interval}
    elapsed=$((elapsed + interval))
done
