#!/bin/bash

[[ -z "$(uname)" ]] && echo "> this script willn't works on windows" && exit 0

command -v code_cli &>/dev/null || echo "code cli not found, sym linking... " && \
	ln -sf $HOME/sync/shared/vscode/code_cli $HOME/.local/bin/code_cli

total=$(jq '.recommendations | length' $HOME/sync/windows/home/AppData/Roaming/Code/User/extensions.json)
count=0

source $DOTFILES/zsh/functions/now
log="$USER_TMP/code_extensions_sync.$(now).log"

echo "> logging into $log"

source $DOTFILES/zsh/functions/progress_bar

jq -r '.recommendations[]' $HOME/sync/windows/home/AppData/Roaming/Code/User/extensions.json | \
	while read ext ; do
		count=$((count+1))

		echo -e "\n\n_ $ext\n" >> $log

		text=""

		if [[ "$ext" =~ ^"-" ]] ; then
			ext=${ext:1}
			text+="removing"
			code_cli --log error \
				--extensions-dir $HOME/.vscode-server/extensions \
				--user-data-dir $HOME/.vscode-server/data \
				--uninstall-extension $ext &>> $log || true;
		else
			text+="adding"
			code_cli --log error \
				--extensions-dir $HOME/.vscode-server/extensions \
				--user-data-dir $HOME/.vscode-server/data \
				--install-extension $ext &>> $log || true;
		fi

		text+=" $ext"

		progress_bar $count $total "$text"
	done

cat $log
