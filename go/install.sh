#!/usr/bin/env bash

source ./zsh/init/10_debug.zsh

_starting 'go'

source ./zsh/init/31_go.zsh
env | grep GO

VERSION="$(curl --silent https://go.dev/VERSION?m=text)"

_info "installing version $VERSION"

URL="https://golang.org/dl/${VERSION}.linux-amd64.tar.gz"
TMP=$(mktemp -d)
DEST="$TMP/go.tar.gz"

curl -L --progress-bar -o "$DEST" "$URL"

ls -lah "$DEST"

sudo rm -rf "$GOROOT"
sudo tar -C /usr/local -xzf "$DEST"

export PATH=${PATH}:${GOROOT}/bin

go version

_finishing 'go'
