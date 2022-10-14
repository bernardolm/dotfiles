function reset_iptables() {
    CMDS=(ip6tables iptables)
    echo "running for ${CMDS[@]}"

    for p in ${CMDS[@]}; do
        echo "running $p..."

        sudo $p -F
        sudo $p -F FORWARD
        sudo $p -F INPUT
        sudo $p -F OUTPUT
        sudo $p -P FORWARD ACCEPT
        sudo $p -P INPUT ACCEPT
        sudo $p -P OUTPUT ACCEPT
        sudo $p -t mangle -F
        sudo $p -t mangle -P FORWARD ACCEPT
        sudo $p -t mangle -P INPUT ACCEPT
        sudo $p -t mangle -P OUTPUT ACCEPT
        sudo $p -t mangle -P POSTROUTING ACCEPT
        sudo $p -t mangle -P PREROUTING ACCEPT
        sudo $p -t mangle -X
        sudo $p -t nat -F
        sudo $p -t nat -P OUTPUT ACCEPT
        sudo $p -t nat -P POSTROUTING ACCEPT
        sudo $p -t nat -P PREROUTING ACCEPT
        sudo $p -t nat -X
        sudo $p -X

        echo "finish $p"
    done

    sudo ufw --force reset
    sudo ufw --force enable

    echo "restoring rules"

    bash $SYNC_PATH/ufw-custom.txt

    echo ""

    sudo ufw --force reload
    sudo ufw status numbered
}

function setup_tunnel() {
    sleep 15s
    add_vpn_routes
}

function vpn_hu() {
    figlet "VPN" -f /usr/share/figlet/slant.flf
    # setup_tunnel &
    start_vpn
}

function fix_wifi_wpa_ubuntu_22_04() {
    if [ ! -f /etc/apt/sources.list.d/impish.list ]; then
        sudo /bin/cat <<'EOF' | sudo tee /etc/apt/sources.list.d/impish.list
deb http://archive.ubuntu.com/ubuntu/impish main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/impish-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/impish-security main restricted universe multiverse
EOF
    ; fi
    sudo apt update
    sudo apt -y --allow-downgrades --allow-change-held-packages install wpasupplicant=2:2.9.0-21build1
    sudo apt-mark hold wpasupplicant
    echo -n "Warning! \\n\\tYou need to forget your known Wi-Fi networks with WPA and reconnect.\\n"
}
