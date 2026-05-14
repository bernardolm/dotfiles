#!/usr/bin/env /bin/zsh

shell_debug_state=$SHELL_DEBUG
SHELL_DEBUG=1

case "$(uname -a)" in
*"Darwin"*)
	export DOTFILES_OS='darwin'
	;;

*"Linux"*)
	if grep -qi microsoft /proc/version 2>/dev/null; then
		export DOTFILES_OS="wsl"

	else
		export DOTFILES_OS="linux"
	fi
	;;

*"CYGWIN"* | *"MINGW"* | *"MSYS"*)
	export DOTFILES_OS="windows"
	;;

*)
	echo "I don't know who I'm"
	export DOTFILES_OS='unknown os'
	;;

esac

if [ -z "${DOTFILES_OS_PROFILE}" ]; then
	if [ "$DOTFILES_OS" = "linux" ] && [ -z "${DISPLAY}" ] && [ -z "${WAYLAND_DISPLAY}" ]; then
		export DOTFILES_OS_PROFILE="server"
	else
		export DOTFILES_OS_PROFILE="desktop"
	fi
fi

# echo "welcome to $DOTFILES_OS $DOTFILES_OS_PROFILE"

SHELL_DEBUG=$shell_debug_state
