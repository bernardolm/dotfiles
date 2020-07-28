function install_go_tools () {
    echo "installing tool golang packages..."

    # General helper packages
    GO111MODULE=on go get -v github.com/k0kubun/pp

    # General tools
    GOPATH=~/gopath-tools go get -v github.com/golang/dep/cmd/dep

    # General go mod tools
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/cortesi/modd/cmd/modd
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/liudng/dogo
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/pkg/profile
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/tsenart/vegeta

    # VS Code Go
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/acroca/go-symbols
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/cweill/gotests/...
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/davidrjenni/reftools/cmd/fillstruct
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/fatih/gomodifytags
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/go-delve/delve/cmd/dlv
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/godoctor/godoctor
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/golangci/golangci-lint/cmd/golangci-lint
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/haya14busa/goplay/cmd/goplay
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/josharian/impl
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/mdempsky/gocode
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/mgechev/revive
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/ramya-rao-a/go-outline
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/rogpeppe/godef
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/sqs/goreturns
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/stamblerre/gocode
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/tylerb/gotype-live
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/uudashr/gopkgs/v2/cmd/gopkgs
    GO111MODULE=on GOPATH=~/gopath-tools go get -v github.com/zmb3/gogetdoc
    GO111MODULE=on GOPATH=~/gopath-tools go get -v golang.org/x/lint/golint
    GO111MODULE=on GOPATH=~/gopath-tools go get -v golang.org/x/tools/cmd/goimports
    GO111MODULE=on GOPATH=~/gopath-tools go get -v golang.org/x/tools/cmd/gorename
    GO111MODULE=on GOPATH=~/gopath-tools go get -v golang.org/x/tools/cmd/guru
    GO111MODULE=on GOPATH=~/gopath-tools go get -v golang.org/x/tools/gopls
    GO111MODULE=on GOPATH=~/gopath-tools go get -v honnef.co/go/tools/...
    GO111MODULE=on GOPATH=~/gopath-tools go get -v winterdrache.de/goformat/goformat

    echo "installing OK"
}
