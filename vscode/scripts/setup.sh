#!/usr/bin/env /bin/zsh
((SHELL_DEBUG)) || set -e

echo "> code setup os: $OS"
[[ -z "$OS" ]] && echo "> os unknown" && return
echo "> setting up code in $OS"

ROOT=$(realpath "${0:A:h}")
echo "> code setup root: $ROOT"

case $OS in
windows)
	echo "> this script will not works on windows"
	return
	;;
wsl)
	# run before:
	# .\Dropbox\windows\bin\code-cli.exe version use stable --install-dir 'C:\Users\bernardo\AppData\Local\Programs\Microsoft VS Code'
	CODE_CLI_TARGET="$HOME/bin/code-cli.exe"
	CODE_CLI_URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-win32-x64"
	CODE_EXTENSIONS_DIR="/mnt/c/Users/$USER/.vscode/extensions"
	CODE_USER_DATA_DIR="/mnt/c/Users/$USER/AppData/Roaming/Code/User"
	;;
darwin)
	CODE_CLI_DIR="$HOME/bin"

	CODE_CLI_BIN="$CODE_CLI_DIR/code-cli"
	CODE_CLI_FILE="$CODE_CLI_DIR/code-cli.zip"
	CODE_CLI_URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-darwin-arm64"

	CODE_EXTENSIONS_DIR="$HOME/.vscode/extensions"
	CODE_USER_DATA_DIR="$HOME/Library/Application Support/Code/User"
	;;
linux)
	CODE_CLI_TARGET="$HOME/bin/code-cli"
	CODE_CLI_URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64"
	CODE_EXTENSIONS_DIR="$HOME/.vscode/extensions"
	CODE_USER_DATA_DIR="$HOME/.config/Code/User"
	;;
*)
	echo "> os unknown"
	return
	;;
esac

echo "> code_cli_bin: $CODE_CLI_BIN"
echo "> code_cli_dir: $CODE_CLI_DIR"
echo "> code_cli_file: $CODE_CLI_FILE"
echo "> code_cli_url: $CODE_CLI_URL"
echo "> code_extensions_dir: $CODE_EXTENSIONS_DIR"
echo "> code_user_data_dir: $CODE_USER_DATA_DIR"

case $OS in
darwin | linux)
	[ ! -d "$HOME/bin" ] && mkdir -p $HOME/bin
	((SHELL_DEBUG)) && /bin/rm -f $HOME/bin/* || true

	if ! test -f "$CODE_CLI_BIN"; then
		echo "> code cli not found"

		if ! test -f "$CODE_CLI_FILE"; then
			echo "> code cli downloading"
			curl -sLo "$CODE_CLI_FILE" "$CODE_CLI_URL"
		fi

		echo "> code cli extracting"
		tar -xf "$CODE_CLI_FILE" -C "$CODE_CLI_DIR"
		/bin/mv "$CODE_CLI_DIR/code" "$CODE_CLI_BIN"
		chmod u+x "$CODE_CLI_BIN"
		"$CODE_CLI_BIN" --status | sed -n '2,2p'
		/bin/rm -f "$CODE_CLI_FILE"
	fi

	PATH="$PATH:$HOME/bin"

	export CODE_CLI_BIN
	export CODE_CLI_DIR
	export CODE_CLI_FILE
	export CODE_CLI_URL
	export CODE_EXTENSIONS_DIR
	export CODE_USER_DATA_DIR
	;;
*)
	echo "> don't know install code cli for $OS"
	return
	;;
esac

echo "> code setup done"
