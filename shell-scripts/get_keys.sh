function get_keys() {
    # ha.pool.sks-keyservers.net
    # hkp://keys.gnupg.net
    # http://keyserver.ubuntu.com
    # keyserver.linuxmint.com
    # subkeys.pgp.net

    if [[ "$(command -v curl)" == "" ]]; then
        sudo apt install --yes curl
    fi

    sudo apt-get update 2>&1 1>/dev/null | sed -ne 's/.*NO_PUBKEY //p' |
    while read key; do
        echo "processing key: $key"
        sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "$key"
    done

    # Others
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
}
