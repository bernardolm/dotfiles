function go_packages_sanitize() {
    echo "cleaning old golang packages..."

    ls $GOPATH/bin | xargs -n1 -I % trash "$GOPATH/bin/%"
    find $GOPATH/src -mindepth 2 -maxdepth 2 -type d | grep -vE "$GITHUB_ORG|$GITHUB_USER" | xargs -n1 -I % trash "%"

    echo "cleaning OK"
}

function go_install_tools() {
    echo "installing golang tools package..."

    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin

    go install -v github.com/acroca/go-symbols@latest
    go install -v github.com/cortesi/modd/cmd/modd@latest
    go install -v github.com/cweill/gotests/...@latest
    go install -v github.com/davidrjenni/reftools/cmd/fillstruct@latest
    go install -v github.com/fatih/gomodifytags@latest
    go install -v github.com/go-delve/delve/cmd/dlv@latest
    go install -v github.com/godoctor/godoctor@latest
    go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install -v github.com/haya14busa/goplay/cmd/goplay@latest
    go install -v github.com/josharian/impl@latest
    go install -v github.com/liudng/dogo@latest
    go install -v github.com/mdempsky/gocode@latest
    go install -v github.com/mgechev/revive@latest
    go install -v github.com/odeke-em/drive/cmd/drive@latest
    go install -v github.com/pkg/profile@latest
    go install -v github.com/ramya-rao-a/go-outline@latest
    go install -v github.com/rogpeppe/godef@latest
    go install -v github.com/sqs/goreturns@latest
    go install -v github.com/stamblerre/gocode@latest
    go install -v github.com/tsenart/veinstalla@latest
    go install -v github.com/tylerb/gotype-live@latest
    go install -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
    go install -v github.com/zmb3/goinstalldoc@latest
    go install -v golang.org/x/lint/golint@latest
    go install -v golang.org/x/tools/cmd/goimports@latest
    go install -v golang.org/x/tools/cmd/gorename@latest
    go install -v golang.org/x/tools/cmd/guru@latest
    go install -v golang.org/x/tools/gopls@latest
    go install -v honnef.co/go/tools/...@latest
    go install -v mvdan.cc/sh/v3/cmd/shfmt@latest
    go install -v winterdrache.de/goformat/goformat@latest

    echo "install finish"
}
