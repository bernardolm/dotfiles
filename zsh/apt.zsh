function apt_search_installed() {
    apt list --installed "*$1*" 2>/dev/null | awk -F'/' 'NR>1{print $1}'
}

function apt_keys_recovery() {
    ## 1password
    if [ ! -f /etc/apt/trusted.gpg.d/1password.gpg ]; then
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /etc/apt/trusted.gpg.d/1password.gpg
    fi

    ## docker
    if [ ! -f /etc/apt/trusted.gpg.d/docker.gpg ]; then
        sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
    fi

    # curl -s https://packagecloud.io/install/repositories/eugeny/tabby/script.deb.sh | sudo bash

    declare -a servers=(
        "keyserver.ubuntu.com"
        "keys.openpgp.org"
        "keys.gnupg.net"
        "pgp.mit.edu"
    )

    sudo apt update 2>&1 | sed -nr 's/^.*NO_PUBKEY\s(\w{16}).*$/\1/p' | sort | uniq | while read -r key; do
        _starting "no pubkey recover for ${key}"

        for server in "${servers[@]}"; do
            _info "trying recover key from ${server}"
            sudo apt-key adv --keyserver ${server} --recv-keys ${key} && break
        done

        sudo apt-key export ${key} 2>/dev/null | sudo gpg --batch --yes --dearmour -o /etc/apt/trusted.gpg.d/${key}.gpg

        [ -f /etc/apt/trusted.gpg ] && sudo rm /etc/apt/trusted.gpg

        _finishing "pubkey ${key} recover"
    done
}
