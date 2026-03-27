#!/usr/bin/env /bin/zsh

export TMPPREFIX=${TMPDIR%/}/zsh
mkdir -p -m 700 "$TMPPREFIX"
