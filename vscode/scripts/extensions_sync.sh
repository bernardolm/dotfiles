#!/usr/bin/env /bin/zsh

[[ -z "$(uname)" ]] && echo "> this script willn't works on windows" && exit 0

command -v code_cli &>/dev/null || echo "code cli not found, sym linking... " && \
	ln -sf $HOME/sync/shared/vscode/code_cli $HOME/.local/bin/code_cli

total=$(jq '.recommendations | length' $HOME/sync/windows/home/AppData/Roaming/Code/User/extensions.json)
count=0

source $DOTFILES/zsh/functions/now
log="$TMP_USER/code_extensions_sync.$(now).log"

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
			code_cli \
				--extensions-dir $HOME/.vscode-server/extensions \
				--force \
				--log error \
				--uninstall-extension $ext \
				--user-data-dir $HOME/.vscode-server/data \
				&>> $log || true ;
		else
			text+="adding"
			code_cli \
				--extensions-dir $HOME/.vscode-server/extensions \
				--force \
				--install-extension $ext \
				--log error \
				--user-data-dir $HOME/.vscode-server/data \
				&>> $log || true ;
		fi

		text+=" $ext"

		progress_bar $count $total "$text"
	done

cat $log
