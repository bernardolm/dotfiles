function dockerdns_sanitize_vestiges() (
    echo "sanitizing docker-dns vestiges"

    grep -v 'docker-dns' /etc/resolv.conf | sudo tee /etc/resolv.conf.tmp > /dev/null
    /bin/cat /etc/resolv.conf.tmp | sudo tee /etc/resolv.conf > /dev/null

    grep -v 'docker-dns' /etc/resolvconf/resolv.conf.d/head | sudo tee /etc/resolvconf/resolv.conf.d/head.tmp > /dev/null
    /bin/cat /etc/resolvconf/resolv.conf.d/head.tmp | sudo tee /etc/resolvconf/resolv.conf.d/head > /dev/null

    sudo resolvconf -u
)

function dockerdns_install() {
    echo "installing docker-dns"

    if [[ $(docker_install_check) -eq 1 ]]; then
        echo "docker isn't installed"
        return
    fi

    if [[ `docker ps -a -q --filter name=ns0 | wc -l | bc` -gt 0 ]]; then
        echo "stopping and removing container"
        docker stop ns0
        docker rm ns0
    fi

    if [[ `docker images -q --filter reference=hu/ns0 | wc -l | bc` -gt 0 ]]; then
        echo "removing image"
        docker rmi hu/ns0:latest
    fi

    dockerdns_sanitize_vestiges

    function _install_1_x() {
        echo "installing 1.x version"

        # git checkout version/1.x
        # git pull origin version/1.x

        make install tag=hu/ns0 name=ns0 tld=hud
    }

    function _install_lastest() {
        echo "installing latest version"

        # git checkout master
        # git pull origin master

        sudo ./bin/docker-dns install -t hu/ns0 -d hud -n ns0
    }

    local last_pwd=`pwd`

    cd $WORKSPACE_USER/docker-dns

    git fetch --prune

    _install_lastest
    # _install_1_x

    cd $last_pwd
}
