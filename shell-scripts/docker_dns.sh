function sanitize_dockerdns_vestiges() (
    echo "sanitizing docker-dns vestiges"

    grep -v 'docker-dns' /etc/resolv.conf | sudo tee /etc/resolv.conf.tmp > /dev/null
    /bin/cat /etc/resolv.conf.tmp | sudo tee /etc/resolv.conf > /dev/null

    grep -v 'docker-dns' /etc/resolvconf/resolv.conf.d/head | sudo tee /etc/resolvconf/resolv.conf.d/head.tmp > /dev/null
    /bin/cat /etc/resolvconf/resolv.conf.d/head.tmp | sudo tee /etc/resolvconf/resolv.conf.d/head > /dev/null
)

function install_dockerdns() {
    echo "installing docker-dns"
    sanitize_dockerdns_vestiges
    git -C $WORKSPACE_USER/docker-dns checkout .
    git -C $WORKSPACE_USER/docker-dns checkout version/1.x
    git -C $WORKSPACE_USER/docker-dns fetch --prune
    git -C $WORKSPACE_USER/docker-dns pull
    make -C $WORKSPACE_USER/docker-dns install tag=hu/ns0 name=ns0 tld=hud
}
