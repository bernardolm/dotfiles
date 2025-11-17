#!/bin/sh

if [ "$OS" = "windows" ]; then
	echo "> I don't know what to do :("
	echo "> maybe use sync/bin/envsubst.exe"
	exit 0
fi

envsubst < ~/sync/shared/vs.code-workspace > ~/sync/$OS/vs.code-workspace
code ~/sync/$OS/vs.code-workspace
