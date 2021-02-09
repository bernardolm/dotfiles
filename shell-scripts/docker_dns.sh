function sanitize_dockerdns_vestiges() (
    echo "sanitizing docker-dns vestiges"

    grep -v 'docker-dns' /etc/resolv.conf | sudo tee /etc/resolv.conf.tmp > /dev/null
    /bin/cat /etc/resolv.conf.tmp | sudo tee /etc/resolv.conf > /dev/null

    grep -v 'docker-dns' /etc/resolvconf/resolv.conf.d/head | sudo tee /etc/resolvconf/resolv.conf.d/head.tmp > /dev/null
    /bin/cat /etc/resolvconf/resolv.conf.d/head.tmp | sudo tee /etc/resolvconf/resolv.conf.d/head > /dev/null

    sudo resolvconf -u
)

function install_dockerdns() {
    echo "installing docker-dns"
    sanitize_dockerdns_vestiges

    function install_dockerdns_1_x() {
        echo "installing 1.x version"

        git \
            --work-tree=$WORKSPACE_USER/docker-dns \
            --git-dir=$WORKSPACE_USER/docker-dns/.git \
            -C $WORKSPACE_USER/docker-dns \
            checkout version/1.x
        git \
            --work-tree=$WORKSPACE_USER/docker-dns \
            --git-dir=$WORKSPACE_USER/docker-dns/.git \
            -C $WORKSPACE_USER/docker-dns \
            pull

        make \
            --directory=$WORKSPACE_USER/docker-dns \
            --makefile=$WORKSPACE_USER/docker-dns/Makefile \
            install tag=hu/ns0 name=ns0 tld=hud
    }

    function install_dockerdns_lastest() {
        echo "installing latest version"

        git \
            --work-tree=$WORKSPACE_USER/docker-dns \
            --git-dir=$WORKSPACE_USER/docker-dns/.git \
            -C $WORKSPACE_USER/docker-dns \
            checkout master
        git \
            --work-tree=$WORKSPACE_USER/docker-dns \
            --git-dir=$WORKSPACE_USER/docker-dns/.git \
            -C $WORKSPACE_USER/docker-dns \
            pull

        sudo $WORKSPACE_USER/docker-dns/bin/docker-dns install -t hu/ns0 -d hud -n ns0
    }

    git \
        --work-tree=$WORKSPACE_USER/docker-dns \
        --git-dir=$WORKSPACE_USER/docker-dns/.git \
        -C $WORKSPACE_USER/docker-dns \
        fetch --prune
    # git \
    #     --work-tree=$WORKSPACE_USER/docker-dns \
    #     --git-dir=$WORKSPACE_USER/docker-dns/.git \
    #     -C $WORKSPACE_USER/docker-dns \
    #     checkout .

    install_dockerdns_lastest
}
