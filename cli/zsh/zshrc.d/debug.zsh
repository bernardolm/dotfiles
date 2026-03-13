return

setopt ERR_EXIT
set -e

# Source - https://superuser.com/a/1840396
# Posted by Silas, modified by community. See post 'Timeline' for change history
# Retrieved 2026-01-08, License - CC BY-SA 4.0
su $USER -ls /bin/zsh -c 'setopt; echo -e $startup_trace; exit'

# zsh --sourcetrace -lixc '' 2>&1 | grep -E '<sourcetrace>' | cut -d '>' -f1

# `setopt` to show zsh current options
# `emulate -lLR zsh` to show zsh default options
# `emulate -LR zsh` to revert to zsh default options
# `functions -t vnc` to debug function
# `rm -f ~/.zcompdump % compinit` when building and debugging your own completion files, you may need to delete this file to force a rebuild

# sudo systemsetup -getRemoteLogin
# system_profiler
