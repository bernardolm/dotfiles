function go_packages_sanitize() {
    echo "cleaning old golang packages..."

    ls $GOPATH/bin | xargs -n1 -I % trash "$GOPATH/bin/%"
    find $GOPATH/src -mindepth 2 -maxdepth 2 -type d | grep -vE "$GITHUB_ORG|$GITHUB_USER" | xargs -n1 -I % trash "%"

    echo "cleaning OK"
}

function go_install_tools() {
    echo "installing golang tools..."

    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin


    /bin/cat $DOTFILES/go/install.txt | grep -v '#' | while read -r pkg; do
        go install $pkg > /dev/null;
    done

    echo "install finish"
}
