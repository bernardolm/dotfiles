#!/usr/bin/env /bin/zsh
# ((SHELL_DEBUG)) || set -e

echo "> code setup os: $OS"
[[ -z "$OS" ]] && echo "> os unknown" && return
echo "> setting up code in $OS"

ROOT=$(realpath "${0:A:h}")
echo "> code setup root: $ROOT"

case $OS in
windows)
	# CODE_CLI_DIR="$HOME/bin"
	CODE_CLI_DIR="/mnt/c/Users/bernardo/bin" # "C:/Users/bernardo/bin"

	CODE_CLI_BIN="$CODE_CLI_DIR/code-cli.exe"
	CODE_CLI_FILE="$CODE_CLI_DIR/code.exe"
	CODE_CLI_FILE_C="$CODE_CLI_DIR/code-cli.zip"
	CODE_CLI_URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-win32-x64"

	# CODE_EXTENSIONS_DIR="/mnt/c/Users/bernardo/.vscode/extensions" # "C:/Users/bernardo/.vscode/extensions"
	# CODE_EXTENSIONS_DIR="c:\\Users\\bernardo\\.vscode\\extensions" # "C:/Users/bernardo/.vscode/extensions"
	CODE_EXTENSIONS_DIR="c:/Users/bernardo/.vscode/extensions" # "C:/Users/bernardo/.vscode/extensions"
	# CODE_USER_DATA_DIR="/mnt/c/Users/bernardo/AppData/Roaming/Code/User" # "C:/Users/bernardo/AppData/Roaming/Code/User"
	# CODE_USER_DATA_DIR="c:\\Users\\bernardo\\AppData\\Roaming\\Code\\User" # "C:/Users/bernardo/AppData/Roaming/Code/User"
	CODE_USER_DATA_DIR="c:/Users/bernardo/AppData/Roaming/Code/User" # "C:/Users/bernardo/AppData/Roaming/Code/User"
	# CODE_USE_VERSION=" --use-version '/mnt/c/Users/bernardo/AppData/Local/Programs/Microsoft\ VS\ Code' "
	# CODE_USE_VERSION=" --use-version 'c:\\Users\\bernardo\\AppData\\Local\\Programs\\Microsoft\\ VS\\ Code' "
	CODE_USE_VERSION=" --use-version 'c:/Users/bernardo/AppData/Local/Programs/Microsoft\ VS\ Code' "

	# c:\Users\bernardo\AppData\Local\Programs\Microsoft VS Code\bin
	# C:\Users\bernardo\AppData\Local\Programs\Microsoft VS Code\Code.exe # SEM CONSOLE

	# WORKS
	# C:\Users\bernardo\Dropbox\windows\bin\code.exe --extensions-dir "C:\Users\bernardo\.vscode\extensions" --user-data-dir "C:\Users\bernardo\AppData\Roaming\Code\User" --use-version "C:\Users\bernardo\AppData\Local\Programs\Microsoft VS Code" --install-extension ms-dotnettools.csharp

	;;
wsl)
	# run before:
	# .\Dropbox\windows\bin\code-cli.exe version use stable --install-dir 'C:\Users\bernardo\AppData\Local\Programs\Microsoft VS Code'
	CODE_CLI_DIR="$HOME/bin"

	# CODE_CLI_BIN="$CODE_CLI_DIR/code-cli.exe"
	CODE_CLI_BIN="$CODE_CLI_DIR/code-cli"
	# CODE_CLI_FILE="$CODE_CLI_DIR/code.exe"
	CODE_CLI_FILE="$CODE_CLI_DIR/code"
	# CODE_CLI_FILE_C="$CODE_CLI_DIR/code-cli.zip"
	CODE_CLI_FILE_C="$CODE_CLI_DIR/code-cli.tar.gz"
	# CODE_CLI_URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-win32-x64"
	CODE_CLI_URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64"

	# CODE_EXTENSIONS_DIR="/mnt/c/Users/$USER/.vscode/extensions"
	CODE_EXTENSIONS_DIR="$HOME/.vscode-server/extensions"
	CODE_USER_DATA_DIR="/mnt/c/Users/$USER/AppData/Roaming/Code/User"
	;;
darwin)
	CODE_CLI_DIR="$HOME/bin"

	CODE_CLI_BIN="$CODE_CLI_DIR/code-cli"
	CODE_CLI_FILE="$CODE_CLI_DIR/code"
	CODE_CLI_FILE_C="$CODE_CLI_DIR/code-cli.zip"
	CODE_CLI_URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-darwin-arm64"

	CODE_EXTENSIONS_DIR="$HOME/.vscode/extensions"
	CODE_USER_DATA_DIR="$HOME/Library/Application Support/Code/User"
	;;
linux)
	CODE_CLI_DIR="$HOME/bin"

	CODE_CLI_BIN="$CODE_CLI_DIR/code-cli"
	CODE_CLI_FILE="$CODE_CLI_DIR/code"
	CODE_CLI_FILE_C="$CODE_CLI_DIR/code-cli.tar.gz"
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
echo "> code_cli_file_c: $CODE_CLI_FILE_C"
echo "> code_cli_url: $CODE_CLI_URL"
echo "> code_extensions_dir: $CODE_EXTENSIONS_DIR"
echo "> code_user_data_dir: $CODE_USER_DATA_DIR"

case $OS in
darwin | linux | wsl | windows)
	[ ! -d "$CODE_CLI_DIR" ] && mkdir -p "$CODE_CLI_DIR"
	((SHELL_DEBUG)) && /bin/rm -f $CODE_CLI_DIR/* || true

	if ! test -f "$CODE_CLI_BIN"; then
		echo "> code cli not found"

		if ! test -f "$CODE_CLI_FILE_C"; then
			echo "> code cli downloading"
			curl -sLo "$CODE_CLI_FILE_C" "$CODE_CLI_URL"
		fi

		echo "> code cli extracting"
		if [[ "$CODE_CLI_FILE_C" == *".tar.gz" ]]; then
			tar -xzf "$CODE_CLI_FILE_C" -C "$CODE_CLI_DIR"
		elif [[ "$CODE_CLI_FILE_C" == *".zip" ]]; then
			unzip -o "$CODE_CLI_FILE_C" -d "$CODE_CLI_DIR"
		else
			echo "> can't uncompress this file"
			return
		fi

		# if [[ "$CODE_CLI_FILE" != *".exe" ]]; then
		chmod u+x "$CODE_CLI_FILE"
		# fi

		/bin/mv "$CODE_CLI_FILE" "$CODE_CLI_BIN"
		"$CODE_CLI_BIN" --status | sed -n '2,2p'
		# /bin/rm -f "$CODE_CLI_FILE"
	fi

	export PATH="$CODE_CLI_DIR:$PATH"

	export CODE_CLI_BIN
	export CODE_EXTENSIONS_DIR
	export CODE_USER_DATA_DIR
	;;
*)
	echo "> I don't know install code cli for $OS"
	return
	;;
esac

echo "> code setup done"
