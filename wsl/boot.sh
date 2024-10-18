#!/usr/bin/env bash

# General values
username=bernardo
distribution="Ubuntu-24.04"
vhd_file_path="C:/Users/${username}/ubuntu-home-64gb.vhd"

# Timeout and interval in seconds
timeout=10
interval=1

# Drive to check and mount
target_drive="/dev/sdc1"

# Mount point
mount_point="/home/${username}"

# Execute mount
eval "/mnt/c/Users/${username}/AppData/Local/Microsoft/WindowsApps/wsl.exe -d $distribution --mount --vhd ${vhd_file_path} --bare"

# Initialize elapsed time counter
elapsed=0

# Wait for the target drive to be ready
while [ ! -e ${target_drive} ]; do
    if [ ${elapsed} -ge ${timeout} ]; then
        echo "Timed out waiting for ${target_drive} to be ready."
        exit 1
    fi

    echo "Waiting for ${target_drive} to be ready..."
    sleep ${interval}
    elapsed=$((elapsed + interval))
done

# Mount the target drive
eval "mount -o defaults,permissions ${target_drive} ${mount_point}"

eval "mount -l | grep ${target_drive}"
