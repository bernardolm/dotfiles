sudo() {
	# shellcheck disable=SC2312
	if [ "$(id -u)" -eq 0 ]; then
		"$@"
	else
		if ! command sudo --non-interactive true 2>/dev/null; then
			warn "Root privileges are required, please enter your password below"
			command sudo --validate
		fi
		command sudo "$@"
	fi
}
