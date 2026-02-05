# ssh-agent -s > "$HOME/.ssh/ssh-agent"
# eval "$(cat "$HOME/.ssh/ssh-agent")"
# ssh-add
# ssh-add -l
# ssh-add -L

if [ "$(uname)" != "Darwin" ] ; then
	ssh-agent -s > ~/.ssh/ssh-agent ; eval `cat ~/.ssh/ssh-agent` 1>/dev/null ; ssh-add ; ssh-add -l >/dev/null
fi
