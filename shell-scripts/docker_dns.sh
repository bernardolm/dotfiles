function sanitize_dockerdns_vestiges() {
    grep -v 'docker-dns' /etc/resolv.conf | sudo tee /etc/resolv.conf.tmp
    sudo mv /etc/resolv.conf.tmp /etc/resolv.conf
}

function install_dockerdns() {
    echo "installing dockerdns"
    check_docker_install || return true
    sanitize_dockerdns_vestiges
    git -C $WORKSPACE_USER/docker-dns checkout .
    git -C $WORKSPACE_USER/docker-dns checkout version/1.x
    git -C $WORKSPACE_USER/docker-dns fetch --prune
    git -C $WORKSPACE_USER/docker-dns pull
    make -C $WORKSPACE_USER/docker-dns install tag=hu/ns0 name=ns0 tld=hud
}
