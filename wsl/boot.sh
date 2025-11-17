#!/usr/bin/env /bin/zsh

# Configuration
disk_uuid=D6623F1C623F00B3
distro_name="${WSL_DISTRO_NAME:=Ubuntu-24.04}"
elapsed=0
interval=2
timeout=10
username=bernardo

# Dynamic configuration
mount_point="/home/${username}"
virtual_disk_path="C:/wsl/${distro_name}/ubuntu-home-64gb.vhd"

# Attaching virtual disk to WSL
function attach_vhd_to_wsl() {
    cmd="/mnt/c/Users/${username}/AppData/Local/Microsoft/WindowsApps/wsl.exe -d ${distro_name} --mount --vhd ${virtual_disk_path} --bare"
    echo "> ${cmd}"
    eval "${cmd} | echo already attached" 2>/dev/null
}

function mount_home() {
    # Umounting exist mounting point
    cmd="umount ${mount_point}"
    echo "> ${cmd}"
    eval "${cmd}"

    # Discovering disk path by UUID
    disk_path=$(blkid --uuid "${disk_uuid}")
    [ -z "${disk_path}" ] && echo "failed to get disk path" && exit 1

    # Mounting disk to home path
    cmd="mount -o defaults,permissions ${disk_path} ${mount_point}"
    echo "> ${cmd}"
    eval "${cmd}"

    # Showing mounted
    cmd="mount -l | grep ${mount_point}"
    echo "> ${cmd}"
    eval "${cmd}"
}

sleep 1

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
