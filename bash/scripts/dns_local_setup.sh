#!/usr/bin/env bash

#
# Basically, its function is to raise a local name server (DNS) inside a docker
# container. Make changes to the OS (Ubuntu only for now) to use this server
# instead of the default one (in this case, ststemd-resolved).
# This name server will try to resolve names from a previously configured
# domain among docker containers. If not, it will use a fallback name server,
# in addition to using the router to which the computer is connected as a name
# server too.
#
# How to call?
# wget -q -O - https://raw.githubusercontent.com/bernardolm/dotfiles/master/bash/scripts/dns_local_setup.sh | bash
# P.S.: pristine Ubuntu linux don't come with curl, but wget.
#
# Dev notes:
# you can call `python3 -m http.server` from dns_local_setup.sh folder
# location to serve it by http on port 8000.
# wget -q -O - http://192.168.1.2:8000/dns_local_setup.sh | bash
#
# TO DO:
#
# [ ] Realod on network change
# [ ] Load custom fallbacks as a list
# [ ] ...
#

function dns_local_setup() {
    function local_dns_instances_running() {
        docker ps -a -q --filter "ancestor=${image_name}:latest"
    }

    function remove_local_dns_instances() {
        printf "> Removing docker containers using %s image if exists.\n" "$image_name"
        while : ; do
            container_id=$(docker ps -a -q --filter "ancestor=${image_name}:latest" | head -n1)
            [ "$container_id" == "" ] && break
            printf "  Container %s found..." "$container_id"
            docker stop "$container_id" 1>/dev/null || exit 1
            docker rm "$container_id" 1>/dev/null || exit 1
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
        ${super} sed -i.bak 's/dns=dnsmasq/#dns=dnsmasq/g' /etc/NetworkManager/NetworkManager.conf
    }

    function turning_dns_default_to_new_containers() {
        printf "\n\nDOCKER_OPTS=\"--dns %s --dns-search %s\"\t# devdns: default DNS for new containers\n\n" "devdns_ip" "$domain" | ${super} tee -a /etc/default/docker 1>/dev/null
    }

    function add_fallback_dns() {
        printf "> Configuring DNS resolver fallback.\n"
        local resolv_conf
        resolv_conf=$(cat < /etc/resolv.conf | grep --color=never -v 'devdns')

        printf "  Your current resolv.conf has:\n"
        show_resolv_conf "$resolv_conf"

        if [[ "$gateway_ip" != "" ]]; then
            resolv_conf=$(echo -ne "\nnameserver $gateway_ip\t# devdns: current DNS from your router gateway\n$resolv_conf")
        fi

        if [[ "$custom_fallback_dns" != "" ]]; then
            resolv_conf=$(echo -ne "$resolv_conf\nnameserver $custom_fallback_dns\t# devdns: your custom fallback DNS\n")
        fi

        if [[ "$gateway_ip$custom_fallback_dns" != "" ]]; then
            printf "  Your changed resolv.conf has:\n"
            show_resolv_conf "$resolv_conf"
        fi

        printf "%s" "$resolv_conf" | ${super} tee /etc/resolv.conf 1>/dev/null
    }

    function test_host() {
        printf "  %s: %s..." "$1" "$2"
        if [ "$(nslookup "$2" | grep -c NXDOMAIN)" != "0" ]; then
            printf " FAILED.\n"
            return 1
        fi
        printf " OK.\n"
    }

    function test_hosts() {
        printf "> Testing name resolver.\n"

        test_host "The docker container created" "$container_name.$domain" || exit 1
        test_host "Some internet name" "www.google.com" || exit 1
        test_host "Some local network name" "spinnaker.hucloud.com.br" || exit 1
    }

    function start_local_dns() {
        printf "> Starting docker container %s.\n" "$container_name"
        docker run \
            -d \
            --privileged=true \
            --name="$container_name" \
            --restart=always \
            -e DNS_DOMAIN="$domain" \
            -e FALLBACK_DNS="$gateway_ip" \
            -e NAMING="$naming" \
            -p 53:53/udp \
            -v /etc/resolv.conf:/mnt/resolv.conf \
            -v /var/run/docker.sock:/var/run/docker.sock \
            "$image_name"

        printf "  Your changed resolv.conf has:\n"
        show_resolv_conf "$(cat /etc/resolv.conf)"
    }

    function install_docker () {
        curl -fsSL "https://get.docker.com" -o /tmp/get-docker.sh || exit 1
        ${super} sh /tmp/get-docker.sh || exit 1
    }

    function setup_docker() {
        ${super} addgroup --system docker || true
        ${super} usermod -G docker "$USER" || true
        newgrp docker || true
    }

    function check_dependencies() {
        printf "> Checking dependencies.\n"

        if [ "$has_docker" == "yes" ]; then
            printf "  Docker install OK.\n"
        else
            printf "  Installing docker.\n"
            printf "  ADVICE:\n"
            printf "  You can check link <https://docs.docker.com/engine/install/ubuntu> for more details.\n"
            printf "  Is important to check link <https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user> too.\n"
            printf "  The official docker installation script <https://get.docker.com> will be used here.\n"
            printf "  Now yes really installing docker... "
            install_docker
            printf "OK.\n"
        fi

        if docker run --rm hello-world &>/dev/null; then
            printf "  Docker setup OK.\n"
        else
            printf "  Setting docker with post install actions... "
            setup_docker &>/dev/null
            printf "OK.\n"
        fi

        printf "  All dependencies OK.\n"
    }

    function ensure_workdir() {
        if ! [ -d "$workdir" ]; then
            mkdir -p "$workdir"
        fi
    }

    function stop_systemd_resolved() {
        printf "> Stopping systemd-resolved, the default ubuntu name resolver.\n"
        ${super} systemctl stop systemd-resolved.service 1>/dev/null
    }

    function apt_cmd() {
        app="$2"
        cmd="$1"
        if [ "$cmd" == "purge" ] && \
            [ "$(apt list --installed 2>/dev/null | grep -c "$app")" == "0" ]; then
            return
        fi
        ${super} apt-get "$cmd" --yes "$app" &>/dev/null || exit 1
    }

    function check_service() {
        ${super} systemctl status "$1.service" | grep -F "Active" | grep -q -E "$2"
    }

    function check_service_active() {
        check_service "$1" " active" # this space before "active" is important!
    }

    function check_service_running() {
        check_service "$1" "running"
    }

    function setup_debian() {
        printf "> Managing OS packages.\n"
        for p in resolvctl dnsmasq; do
            printf "  Removing package %s... " "$p"
            apt_cmd "purge" "$p"
            printf "OK.\n"
        done
        for p in uidmap bind9-utils iproute2 curl; do
            printf "  Installing package %s... " "$p"
            apt_cmd "install" "$p"
            printf "OK.\n"
        done
    }

    function setup_system() {
        printf "> Making system changes to allow a new DNS server be used.\n"

        # for s in dnsmasq systemd-resolved; do
        s=systemd-resolved
        if check_service_active $s; then
            printf "  Service %s is active and will be deactivated... " "$s"
            ${super} systemctl mask $s.service &>/dev/null || exit 1
            printf "OK.\n"
        else
            printf "  Service %s isn't active.\n" "$s"
        fi
        if check_service_running $s; then
            printf "  Service %s is running and will be stopped... " "$s"
            ${super} systemctl stop $s.service &>/dev/null || exit 1
            printf "OK.\n"
        else
            printf "  Service %s isn't running.\n" "$s"
        fi
        # done

        expose_privileged_port_53

        if [ -h /etc/resolv.conf ]; then
            printf "  Removing resolv.conf managed by systemd-resolved\n"
            ${super} mv -f /etc/resolv.conf /etc/resolv.conf.bkp
            ${super} touch /etc/resolv.conf
        fi

        turning_dns_default_to_new_containers
    }

    function expose_privileged_port_53() {
        printf "  Setting privileges to use port 53.\n"
        ${super} sed -i.bak '/ip_unprivileged_port_start\=53/d' /etc/sysctl.conf
        printf "net.ipv4.ip_unprivileged_port_start=53" | ${super} tee -a /etc/sysctl.conf 1>/dev/null
        ${super} sysctl --system &>/dev/null
    }

    function download_docker_image() {
        printf "> Pulling docker image %s.\n" "$image_name"
        if [[ "$(docker images -q $image_name:latest 2>/dev/null)" == "" ]]; then
            docker pull "$image_name:latest" 1>/dev/null || exit 1
        fi
    }

    function check_internet_connection() {
        test_host "" "www.ubuntu.com" &>/dev/null && return
        printf "> Where your internet connection? Check before, please?\n"
        exit 1
    }

    function sudo_advice() {
        if apt install build-essential &>/dev/null; then
            return
        fi

        super="$(which sudo)"

        USER=$(id -un)
        [ -z "$USER" ] && USER=ghost

        printf "> ⚠ Hi %s, your super password (to use $super) will be asked.\n" "$USER"
        tput sc
        ${super} ls 1>/dev/null
        tput rc; tput el
    }

    printf "> Starting DNS setup.\n"

    local super

    sudo_advice

    local container_name="${CONTAINER_NAME:-ns1}"
    local custom_fallback_dns="${CUSTOM_FALLBACK_DNS:-}"
    local domain="${DOMAIN:-hud}"
    local image_name="ruudud/devdns"
    local naming="unsafe"
    local workdir="${WORKSPACE_USER:-"$HOME/.devdns"}"
    # local prohibited_dns="${PROHIBITED_DNS:-'1.1.1.1,1.1.0.0,8.8.8.8,8.8.4.4'}"

    check_internet_connection
    setup_debian

    local gateway_ip
    gateway_ip=$(ip route show | grep -i 'default via' | awk '{ printf $3 }' | head -1)

    local has_docker
    has_docker=$(command -v docker 1>/dev/null && printf "yes")

    check_dependencies
    ensure_workdir
    remove_local_dns_instances
    download_docker_image
    setup_system
    add_fallback_dns
    sleep 1
    start_local_dns
    sleep 1
    test_hosts
    turning_dns_default_to_new_containers
    printf "> DNS setup finished. Enjoy!\n\n"
}

trap "echo; exit" INT

dns_local_setup || exit 1
