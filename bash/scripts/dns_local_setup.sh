#!/usr/bin/env bash

# How to call?
# wget -q -O - https://raw.githubusercontent.com/bernardolm/dotfiles/master/bash/scripts/dns_local_setup.sh | bash
# P.S.: pristine Ubuntu linux don't come with curl, but wget.
#
# Dev notes:
# you can call `python3 -m http.server` from dns_local_setup.sh folder location to serve it by http on port 8000.
# wget -q -O - http://192.168.1.2:8000/dns_local_setup.sh | bash

function dns_local_setup() {
    local container_name="${CONTAINER_NAME:-ns1}"
    local custom_fallback_dns="${CUSTOM_FALLBACK_DNS:-8.8.4.4}"
    local domain="${DOMAIN:-hud}"
    local image_name="ruudud/devdns"
    local naming="unsafe"
    local workdir="${WORKSPACE_USER:-"$HOME/.devdns"}"
    # local prohibited_dns="${PROHIBITED_DNS:-'1.1.1.1,1.1.0.0,8.8.8.8,8.8.4.4'}"

    local gateway_ip
    gateway_ip=$(ip route show | grep -i 'default via' | awk '{ printf $3 }' | head -1)

    local has_curl
    has_curl=$(command -v curl 1>/dev/null && printf "yes")

    local has_docker
    has_docker=$(command -v docker 1>/dev/null && printf "yes")

    function sudo_advice() {
        printf "> ⚠ Your super password (sudo) is required.\n"
        tput sc
        sudo ls 1>/dev/null
        tput rc; tput el
    }

    function local_dns_instances_running() {
        docker ps -a -q --filter "ancestor=${image_name}:latest"
    }

    function remove_local_dns_instances() {
        printf "> Removing docker containers using %s image if exists.\n" "$image_name"
        while : ; do
            container_id=$(docker ps -a -q --filter "ancestor=${image_name}:latest" | head -n1)
            [ "$container_id" == "" ] && break
            printf "  Container %s found..." "$container_id"
            docker stop "$container_id" 1>/dev/null || return 1
            docker rm "$container_id" 1>/dev/null || return 1
            printf " removed.\n"
        done
    }

    function show_resolv_conf() {
        printf "\033[1;36m"
        printf "%s" "$1" | grep --color=never -v -e '^#' | grep --color=never -v -e '^\s*$' | grep --color=never 'nameserver'
        printf "\033[0m"
    }

    function fixing_network_manager_conf() {
        cat < /etc/NetworkManager/NetworkManager.conf | grep --color=never -v -e '^#' | grep --color=never -v -e '^\s*$' | grep --color=never -E '^dns=dnsmasq'
        sudo sed -i.bak 's/dns=dnsmasq/#dns=dnsmasq/g' /etc/NetworkManager/NetworkManager.conf
    }

    function add_fallback_dns() {
        printf "> Configuring DNS resolver fallback.\n"
        local resolv_conf
        resolv_conf=$(cat < /etc/resolv.conf | grep --color=never -v 'devdns:')

        printf "  Your current resolv.conf has:\n"
        show_resolv_conf "$resolv_conf"

        if [[ "$gateway_ip" != "" ]]; then
            resolv_conf=$(echo -ne "$resolv_conf\nnameserver $gateway_ip\t# devdns: current DNS from your router gateway\n")
        fi

        if [[ "$custom_fallback_dns" != "" ]]; then
            resolv_conf=$(echo -ne "$resolv_conf\nnameserver $custom_fallback_dns\t# devdns: your custom fallback DNS\n")
        fi

        if [[ "$gateway_ip$custom_fallback_dns" != "" ]]; then
            printf "  Your changed resolv.conf has:\n"
            show_resolv_conf "$resolv_conf"
        fi

        printf "%s" "$resolv_conf" | sudo tee /etc/resolv.conf 1>/dev/null
    }

    function test_host() {
        printf "  %s: %s..." "$1" "$2"
        if [ "$(nslookup $2 | grep -c NXDOMAIN)" != "0" ]; then
            printf " FAILED.\n"
            return 1
        fi
        printf " OK.\n"
    }

    function test_hosts() {
        printf "> Testing name resolver.\n"

        test_host "The docker container created" "$container_name.$domain" || return 1
        test_host "Some internet name" "www.google.com" || return 1
        test_host "Some local network name" "spinnaker.hucloud.com.br" || return 1
    }

    function start_local_dns() {
        printf "> Starting docker container %s.\n" "$container_name"

        mkdir -p "$HOME/.$container_name/dnsmasq-hosts.d"

        newgrp docker 1>/dev/null || true
        $(which docker) run -d \
            --name="$container_name" \
            --restart=always \
            -e DNS_DOMAIN="$domain" \
            -e FALLBACK_DNS="$gateway_ip" \
            -e NAMING="$naming" \
            -p 53:53/udp \
            -v /etc/resolv.conf:/mnt/resolv.conf \
            -v /var/run/docker.sock:/var/run/docker.sock:ro \
            "$image_name"
    }

    function install_docker () {
        printf "  Installing docker.\n"
        printf "  You can check link https://docs.docker.com/engine/install/ubuntu/ for more details.\n"
        printf "  Is important to check link https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user too.\n"
        printf "  Now the official docker installation script will be called.\n"
        curl -fsSL "https://get.docker.com" -o /tmp/get-docker.sh
        sudo sh /tmp/get-docker.sh 1>/dev/null
    }

    function setup_docker() {
        printf "  Running docker post install.\n"
        getent group docker 1>/dev/null || sudo groupadd docker 1>/dev/null
        sudo usermod -aG docker "$USER"
        newgrp docker
        sudo apt-get install --yes uidmap &>/dev/null && dockerd-rootless-setuptool.sh install 1>/dev/null
    }

    function check_dependencies() {
        printf "> Checking dependencies.\n"

        if [ "$has_curl" == "yes" ]; then
            printf "  Curl OK.\n"
        else
            printf "  Installing curl.\n"
            sudo apt-get install curl --yes &>/dev/null
        fi

        if [ "$has_docker" == "yes" ]; then
            printf "  Docker installed.\n"
        else
            install_docker
        fi

        if docker run --rm hello-world 1>/dev/null; then
            printf "  Permission to run docker OK.\n"
        else
            setup_docker
        fi

        [ "$has_docker" == "yes" ] && docker run --rm hello-world 1>/dev/null && printf "  Docker OK.\n"

        printf "  All dependencies OK.\n"
    }

    function ensure_workdir() {
        if [ ! -d "$workdir" ]; then
            mkdir -p "$workdir"
        fi
    }

    function stop_systemd_resolved() {
        printf "> Stopping systemd-resolved, the default ubuntu name resolver.\n"
        sudo systemctl stop systemd-resolved.service 1>/dev/null
    }

    function apt_purge() {
        app="$1"
        if [ "$(apt list -a "$app" 2>/dev/null | grep -c 'installed')" -ge 1 ]; then
            sudo apt-get purge --yes "$app" &>/dev/null || return 1
        fi
    }

    function check_service_active() {
        sudo systemctl status "$1.service" 2>/dev/null | grep 'Active: active'
    }

    function check_service_running() {
        sudo systemctl status "$1.service" 2>/dev/null | grep '(running)'
    }

    function disable_default_dns() {
        printf "> Disabling the default ubuntu name resolver.\n"

        for s in dnsmasq systemd-resolved; do
            if check_service_running $s; then
                sudo systemctl stop $s.service 1>/dev/null || return 1
            fi
            if check_service_active $s; then
                sudo systemctl disable $s.service 1>/dev/null || return 1
            fi
        done

        for p in resolvctl dnsmasq; do
            apt_purge "$p"
        done
    }

    function expose_privileged_port_53() {
        printf "> Setting privileges to use port 53.\n"
        sudo sed -i.bak '/ip_unprivileged_port_start\=53/d' /etc/sysctl.conf
        printf "net.ipv4.ip_unprivileged_port_start=53" | sudo tee -a /etc/sysctl.conf 1>/dev/null
        sudo sysctl --system &>/dev/null
    }

    function download_docker_image() {
        printf "> Pulling docker image %s.\n" "$image_name"
        if [[ "$(docker images -q $image_name:latest 2>/dev/null)" == "" ]]; then
            docker pull "$image_name:latest" 1>/dev/null || return 1
        fi
    }

    reset
    printf "> Starting DNS setup.\n"
    sudo_advice
    check_dependencies || return 1
    ensure_workdir || return 1
    remove_local_dns_instances || return 1
    download_docker_image || return 1
    expose_privileged_port_53 || return 1
    disable_default_dns || return 1
    start_local_dns || return 1
    add_fallback_dns || return 1
    test_hosts || return 1
    printf "> DNS setup finished. Enjoy!\n"

    cat /etc/resolv.conf
    printf "\n"
}

trap "echo; exit" INT

dns_local_setup
