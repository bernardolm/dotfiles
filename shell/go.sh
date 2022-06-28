function go_packages_sanitize() {
    echo "cleaning old golang packages..."

    ls $GOPATH/bin | xargs -n1 -I % trash "$GOPATH/bin/%"
    find $GOPATH/src -mindepth 2 -maxdepth 2 -type d | grep -vE "$GITHUB_ORG|$GITHUB_USER" | xargs -n1 -I % trash "%"

    echo "cleaning OK"
}

function go_install_tools() {
    echo "installing golang tools package..."

    # General helper packages
    go get -v github.com/k0kubun/pp

    # General tools
    curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

    # General go mod tools
    go get -v github.com/cortesi/modd/cmd/modd
    go get -v github.com/liudng/dogo
    go get -v github.com/odeke-em/drive/cmd/drive
    go get -v github.com/pkg/profile
    go get -v github.com/tsenart/vegeta

    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin

    # VS Code Go
    go get -v github.com/acroca/go-symbols
    go get -v github.com/cweill/gotests/...
    go get -v github.com/davidrjenni/reftools/cmd/fillstruct
    go get -v github.com/fatih/gomodifytags
    go get -v github.com/go-delve/delve/cmd/dlv
    go get -v github.com/godoctor/godoctor
    go get -v github.com/golangci/golangci-lint/cmd/golangci-lint
    go get -v github.com/haya14busa/goplay/cmd/goplay
    go get -v github.com/josharian/impl
    go get -v github.com/mdempsky/gocode
    go get -v github.com/mgechev/revive
    go get -v github.com/ramya-rao-a/go-outline
    go get -v github.com/rogpeppe/godef
    go get -v github.com/sqs/goreturns
    go get -v github.com/stamblerre/gocode
    go get -v github.com/tylerb/gotype-live
    go get -v github.com/uudashr/gopkgs/v2/cmd/gopkgs
    go get -v github.com/zmb3/gogetdoc
    go get -v golang.org/x/lint/golint
    go get -v golang.org/x/tools/cmd/goimports
    go get -v golang.org/x/tools/cmd/gorename
    go get -v golang.org/x/tools/cmd/guru
    go get -v golang.org/x/tools/gopls
    go get -v honnef.co/go/tools/...
    go get -v mvdan.cc/sh/v3/cmd/shfmt
    go get -v winterdrache.de/goformat/goformat

    echo "install finish"
}
