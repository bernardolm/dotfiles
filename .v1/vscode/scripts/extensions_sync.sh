#!/usr/bin/env /bin/zsh
((SHELL_DEBUG)) && echo "> debug mode on" #|| set -e

DOTFILES=$(realpath "${0:A:h}/../../")
echo "> dotfiles: $DOTFILES"
[[ -z "$DOTFILES" ]] && echo "> dotfiles dir unknown" && return

[[ -z "$OS" ]] && source $DOTFILES/zsh/scripts/os-resolver.sh
echo "> os: $OS"
[[ -z "$OS" ]] && echo "> os unknown" && return

source $DOTFILES/vscode/scripts/setup.sh || return

echo "> code cli path: $CODE_CLI_BIN"
[[ ! -f "$CODE_CLI_BIN" ]] && echo "> code path unknown" && return

if [[ "$OS" != "windows" ]]; then
	echo "> code user data dir: $CODE_USER_DATA_DIR"
	[[ ! -d "$CODE_USER_DATA_DIR" ]] && echo '> code user data dir unknown' && return

	echo "> code extensions dir: $CODE_EXTENSIONS_DIR"
	[[ ! -d "$CODE_EXTENSIONS_DIR" ]] && echo "> code extensions dir unknown" && return
fi

source $DOTFILES/zsh/functions/now
source $DOTFILES/zsh/functions/progress_bar

total=$(/bin/cat $DOTFILES/vscode/extensions.json | grep -v '//' | jq '. | length')
count=0

/bin/cat $DOTFILES/vscode/extensions.json | grep -v '//' | jq -r '.[]' |
	while read ext; do
		[ -z "$ext" ] && continue

		count=$((count + 1))

		signal=${ext: -1}

		case $signal in
			"-")
				code_arg="--force --uninstall-extension"
				ext=${ext%?}
				;;
			# "*")
			# 	code_arg="--disable-extension"
			# 	ext=${ext%?}
			# 	;;
			*)
				code_arg="--force --install-extension"
				;;
		esac

		action="\e[0;36m$code_arg:\e[0m"
		progress="\e[0;35m[$count/$total]\e[0m"

		echo -e "> $action $ext $progress"

		cmd="$CODE_CLI_BIN $CODE_USE_VERSION --log critical --extensions-dir '$CODE_EXTENSIONS_DIR' --user-data-dir '$CODE_USER_DATA_DIR' $code_arg $ext"

		((SHELL_DEBUG)) && echo -e "\e[0;32m$cmd\e[0m"

		(eval $cmd 2>&1 \
			| grep -v 'is not installed' \
			| grep -v 'Make sure' \
			| grep -v 'already installed.' \
		) || true

		echo -e "done\n"

		((SHELL_DEBUG)) && [[ "$count" -ge "3" ]] && break

	done
