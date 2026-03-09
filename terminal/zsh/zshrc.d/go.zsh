export GOPATH="${GOPATH:-$HOME/go}"
if [ -d "/usr/local/go/bin" ] && [[ ":$PATH:" != *":/usr/local/go/bin:"* ]]; then
	export PATH="$PATH:/usr/local/go/bin"
fi
if [ -d "$GOPATH/bin" ] && [[ ":$PATH:" != *":$GOPATH/bin:"* ]]; then
	export PATH="$PATH:$GOPATH/bin"
fi
