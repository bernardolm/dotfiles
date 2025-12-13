#!/usr/bin/env /bin/zsh
# ((SHELL_DEBUG)) || set -e

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

filter_stderr() {
	local input=""
	while IFS= read -r line; do
		input+="$line\n"
	done

	local forbidden_expressions=(
		"Ignoring option"
		"is already installed"
		"is not installed"
		"was successfully installed"
		"was successfully uninstalled"
	)

	for expression in "${forbidden_expressions[@]}"; do
		if [[ "$input" == *"$expression"* ]]; then
			return
		fi
	done

	echo $input
}

/bin/cat $DOTFILES/vscode/extensions.json | grep -v '//' | jq -r '.[]' |
	while read ext; do
		[ -z "$ext" ] && continue

		count=$((count + 1))

		code_arg="--install-extension"
		signal=+

		if [[ "$ext" =~ ^"-" ]]; then
			code_arg="--uninstall-extension"
			signal=-
			ext=${ext:1}
		fi

		echo -e "> $signal $ext [$count/$total]"

		local cmd="$CODE_CLI_BIN $CODE_USE_VERSION --force --log critical --extensions-dir '$CODE_EXTENSIONS_DIR' --user-data-dir '$CODE_USER_DATA_DIR' $code_arg $ext"

		echo -e "$cmd\n"

		eval "$cmd" || true

	done
