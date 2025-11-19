#!/usr/bin/env /bin/zsh

if [ "$OS" = "windows" ]; then
	echo "> I don't know what to do :("
	echo "> maybe use sync/bin/envsubst.exe"
	exit 0
fi

envsubst < ~/sync/shared/default.code-workspace > ~/sync/$OS/$OS.code-workspace
code ~/sync/$OS/$OS.code-workspace
