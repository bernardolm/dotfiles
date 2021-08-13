[ -d /usr/local/go/bin ] && export PATH=$PATH:/usr/local/go/bin:
[ -z $GITHUB_ORG ] && export GOPRIVATE=github.com/$GITHUB_ORG/*
[ -d ~/gopath ] && export GOPATH=~/gopath
[ -d $GOPATH/bin ] && export PATH=$PATH:$GOPATH/bin:
