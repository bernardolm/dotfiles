#!/usr/bin/env /bin/zsh

_uname=$(uname -a)

OS='who I m'

case "$_uname" in
	*"Darwin"*)
		((SHELL_DEBUG)) && echo "I'm a mac"
		OS='darwin'
		;;
	*"WSL"*)
		((SHELL_DEBUG)) && echo "I'm a wsl"
		OS='wsl'
		;;
	*"Linux"*)
		((SHELL_DEBUG)) && echo "I'm a linux"
		OS='linux'
		;;
	*)
		((SHELL_DEBUG)) && echo "I don't know who I'm"
		;;
esac

export OS
