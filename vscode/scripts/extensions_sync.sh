#!/bin/bash

command -v code_cli &>/dev/null || echo "code cli not found, sym linking... " && \
	ln -sf $HOME/sync/shared/vscode/code_cli $HOME/.local/bin/code_cli

total=$(jq '.recommendations | length' $HOME/sync/windows/home/AppData/Roaming/Code/User/extensions.json)
count=0

source $DOTFILES/zsh/functions/now
log="$HOME/tmp/code_extensions_sync.$(now).log"

source $DOTFILES/zsh/functions/progress_bar

jq -r '.recommendations[]' $HOME/sync/windows/home/AppData/Roaming/Code/User/extensions.json | \
	while read ext ; do
		count=$((count+1))

		text="> "

		if [[ "$ext" =~ ^"-" ]] ; then
			ext=${ext:1}
			text+="removing"
			code_cli --uninstall-extension $ext >> $output || true;
		else
			text+="adding"
			code_cli --install-extension $ext >> $output || true;
		fi

		text+=" $ext"

		progress_bar $count $total "$text"
	done
