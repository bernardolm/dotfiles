#!/bin/bash

command -v code_cli &>/dev/null || echo "code cli not found, sym linking... " && \
	ln -sf $HOME/sync/shared/vscode/code_cli $HOME/.local/bin/code_cli

source $HOME/workspaces/bernardolm/dotfiles/zsh/functions/progress_bar

total=$(jq '.recommendations | length' ~/sync/windows/home/AppData/Roaming/Code/User/extensions.json)
count=0

jq -r '.recommendations[]' ~/sync/windows/home/AppData/Roaming/Code/User/extensions.json | \
	while read ext ; do
		count=$((count+1))

		if [[ "$ext" =~ ^"-" ]] ; then
			ext=${ext:1}
			code_cli --uninstall-extension $ext &>/dev/null || true;
		else
			code_cli --install-extension $ext &>/dev/null || true;
		fi

		progress_bar $count $total $ext
	done
