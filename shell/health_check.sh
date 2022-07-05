function health_check() {
    local path_to_scan="/"
    [ ! -z "$1" ] && path_to_scan=$1
    echo "scanning '$path_to_scan'..."
    sudo apt install \
        clamav \
        clamav-base \
        clamav-daemon \
        clamav-freshclam \
        libclamav9 \
        libclamunrar9
    sudo service clamav-freshclam stop
    sudo freshclam
    sudo service clamav-freshclam restart
    clamscan \
        --alert-encrypted=yes \
        --bell \
        --disable-cache \
        --heuristic-alerts=yes \
        --recursive \
        $path_to_scan
}
