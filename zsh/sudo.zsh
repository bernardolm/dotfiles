# function sudo() {
# 	# shellcheck disable=SC2312
# 	if [ "$(id -u)" -eq 0 ]; then
# 		"$@"
# 	else
# 		if ! command sudo --non-interactive true 2>/dev/null; then
# 			_warn "root privileges are required, please enter your password below. pay attention for what you doing!"
# 			command sudo --validate
# 		fi
# 		command sudo "$@"
# 	fi
# }

function sudo() {
	(
		pid=$(exec sh -c 'echo "$PPID"')

		# If the command takes less than .2s, don't change the theme.
		# We could also just match on 'su' and ignore everything else,
		# but this also accomodates other long running commands
		# like 'sudo sleep 5s'. Modify to taste.

		(
				sleep .2s
				ps -p "$pid" > /dev/null && INHIBIT_THEME_HIST=1 theme.sh red-alert
		) &

		trap 'theme.sh "$(theme.sh -l|tail -n1)"' INT
		env sudo "$@"
		theme.sh "$(theme.sh -l|tail -n1)"
	)
}
