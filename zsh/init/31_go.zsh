export GOPATH=$HOME/gopath
[ ! -d "$GOPATH" ] && mkdir -p "$GOPATH"
export PATH=$PATH:$GOPATH/bin

export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH
