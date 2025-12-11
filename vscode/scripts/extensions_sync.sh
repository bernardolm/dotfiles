#!/usr/bin/env /bin/zsh

source "$DOTFILES/zsh/functions/now"
source "$DOTFILES/zsh/functions/progress_bar"

zsh --no-rcs "$DOTFILES/zsh/scripts/os-resolver.sh"

echo "> os: $OS"
echo "> home: $HOME"

[[ -z "$OS" ]] && echo "> os unknown" && exit 0

([[ "$OS" = "windows" ]] || [[ "$OS" = "wsl" ]]) \
	&& echo "> this script willn't works on windows" && exit 0

total=$(/bin/cat $DOTFILES/vscode/extensions.json | grep -v '//' | jq '. | length')
count=0

log="$TMP_USER/code_extensions_sync.$(now).log"

echo "> logging into $log"

/bin/cat $DOTFILES/vscode/extensions.json | grep -v '//' | jq -r '.[]' | \
	while read ext ; do
		count=$((count+1))

		echo -e "\n\n_ $ext\n" >> $log

		text=""

		if [[ "$ext" =~ ^"-" ]] ; then
			ext=${ext:1}
			text=-
				# --extensions-dir $HOME/.vscode-server/extensions \
				# --user-data-dir $HOME/.vscode-server/data \
			code-cli \
				--force \
				--log error \
				--uninstall-extension $ext \
				&>> $log || true ;
		else
			text=+
				# --extensions-dir $HOME/.vscode-server/extensions \
				# --user-data-dir $HOME/.vscode-server/data \
			code-cli \
				--force \
				--install-extension $ext \
				--log error \
				&>> $log || true ;
		fi

		text+=" $ext"

		echo -e "> $count\t$total\t$text"
		# progress_bar $count $total "$text"
	done

cat $log
