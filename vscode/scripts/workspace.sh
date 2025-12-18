#!/usr/bin/env /bin/zsh

if [ "$OS" = "windows" ]; then
	echo "> I don't know what to do :("
	echo "> maybe use sync/bin/envsubst.exe"
	exit 0
fi

template_file="$HOME/sync/shared/default.code-workspace"
target_file="$HOME/sync/$OS/$OS.code-workspace"

envsubst < "$template_file" > "$target_file"
ls -lah "$target_file"
cat "$target_file"
code "$target_file"
