#!/usr/bin/env /bin/zsh
set -e

DOTFILES=$(realpath "${0:A:h}/../../")
echo "> dotfiles: $DOTFILES"
[[ -z "$DOTFILES" ]] && echo "> dotfiles dir unknown" && exit 0

source $DOTFILES/zsh/scripts/os-resolver.sh
echo "> os: $OS"
[[ -z "$OS" ]] && echo "> os unknown" && exit 0

source $DOTFILES/vscode/scripts/setup.sh || exit 0

echo "> code cli path: $CODE_CLI_BIN"
[[ ! -f "$CODE_CLI_BIN" ]] && echo "> code path unknown" && exit 0

echo "> code user data dir: $CODE_USER_DATA_DIR"
[[ ! -d "$CODE_USER_DATA_DIR" ]] && echo '> code user data dir unknown' && exit 0

echo "> code extensions dir: $CODE_EXTENSIONS_DIR"
[[ ! -d "$CODE_EXTENSIONS_DIR" ]] && echo "> code extensions dir unknown" && exit 0

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

		$CODE_CLI_BIN \
			--force \
			--log critical \
			--extensions-dir $CODE_EXTENSIONS_DIR \
			--user-data-dir $CODE_USER_DATA_DIR \
			$code_arg $ext 2>&1 | filter_stderr || true
	done
