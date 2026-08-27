# WezTerm

## Reference and copyleft

- <https://alexplescan.com/posts/2024/08/10/wezterm>
- <https://gist.github.com/alexpls/83d7af23426c8928402d6d79e72f9401>

## Install

```sh
brew install lua luarocks wezterm
luarocks install inspect
```

## Mux domain and background process persistence

`behavior.lua` sets `default_domain = 'unix'`, so every new window/tab spawns
through the `unix` mux domain instead of a plain local process. This is what
lets background processes in a pane survive a `wezterm-gui` restart: the
pane's shell keeps running under `wezterm-mux-server` (a separate process),
and reopening WezTerm reattaches to it — verified repeatedly (kill
`wezterm-gui`, background job keeps running, reopen shows the same panes).

`wezterm-gui` auto-spawns `wezterm-mux-server` on demand the first time it's
needed and it then keeps running in the background on its own — no LaunchAgent
required for the actual persistence goal.

`com.wezterm.mux-server.plist` (in this directory) is an OPTIONAL LaunchAgent
that instead keeps `wezterm-mux-server` always running via `launchd`, so it's
already warm before WezTerm even starts. **It is currently NOT installed** —
tried it while chasing a slow-startup issue that turned out to be caused by
something else (a `sudo`-prompting VPN script as the first startup tab, fixed
in `startup-commads.txt`'s ordering), and it's not needed for persistence.
Only install it if `wezterm-gui`'s on-demand spawn is itself too slow.

To install:

```sh
mkdir -p ~/Library/LaunchAgents
ln -sf ~/dotfiles/cli/wezterm/com.wezterm.mux-server.plist \
	~/Library/LaunchAgents/com.wezterm.mux-server.plist
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.wezterm.mux-server.plist
launchctl enable gui/$(id -u)/com.wezterm.mux-server
```

Useful commands:

```sh
# check status
launchctl print gui/$(id -u)/com.wezterm.mux-server

# stop/unload
launchctl bootout gui/$(id -u)/com.wezterm.mux-server

# logs
tail -f ~/Library/Logs/wezterm-mux-server.log
```

## startup-commads.txt

Each non-comment line is a command to run in its own tab when WezTerm starts
(see `gui-startup.lua`). Lines starting with `ssh host` instead register a
named SSH domain (`config.ssh_domains`, usable via `wezterm connect <name>`
or the launcher) rather than spawning a tab directly.

**Known issue, left enabled anyway (accepted tradeoff):** with
`default_domain = 'unix'`, auto-spawning a tab on launch — for ANY entry
past the first one, local or ssh — can non-deterministically add one extra
tab on top of what was asked for, and on some tested combinations that
extra tab count kept growing on every single relaunch instead of staying
put. Verified across dozens of test cycles switching between a WezTerm
nightly build and the stable release; the stable release was noticeably
better (bounded growth, mostly) but not clean. No config-level fix found.
Keep entries here commented out unless you're deliberately accepting the
risk; if tabs start multiplying, comment them back out and quit/reopen.

## SSH via the 1Password agent

`~/.ssh/config` (symlinked from Dropbox, not tracked by this repo's git)
sets `IdentityAgent` to 1Password's SSH agent socket for `Host *`. Two
things about this setup live outside any versioned file and can silently
break again — if `ssh`/WezTerm's SSH connections start asking for a
password or failing with `Socket error: No such file or directory`, check
these first:

1. **1Password's own `SSH_AUTH_SOCK` LaunchAgent isn't loaded.**
   1Password ships `~/Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist`,
   which symlinks macOS's default `SSH_AUTH_SOCK` target to 1Password's real
   agent socket — this is what WezTerm's built-in SSH client (`libssh-rs`)
   actually ends up using; it doesn't reliably honor `IdentityAgent` from
   `~/.ssh/config` the way plain `ssh` does. Reload it with:

   ```sh
   launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist
   ```

   Verify: `ls -la /var/run/com.apple.launchd.*/Listeners` should show it as
   a symlink into `.../2BUA8C4S2C.com.1password/t/agent.sock`, and
   `ssh-add -l` should list your 1Password-managed keys.

2. **A 1Password *item* can have the wrong host mapped to it.** Each
   `Match Host <ip-or-name>` block in `~/.ssh/1Password/config` (auto-generated
   by the app, do not hand-edit — regenerated from each item's own "SSH
   Keys"/host list) comes from a specific 1Password item. If e.g. `localhost`
   ends up pinned to the wrong item's key, that key gets offered and
   rejected by the real target, and `ssh` fails without ever trying the
   right key (`IdentitiesOnly yes` on every entry). Fix inside the
   1Password app: open the wrong item, remove the stray host from it, add
   it to the correct item instead.

`~/.ssh/config` itself also had `IdentityAgent "~/Library/Group Containers/..."`
with a literal `~` — WezTerm's SSH client didn't expand it (plain `ssh`
does). Fixed to the absolute `/Users/bernardo/Library/Group Containers/...`
path. Worth knowing if that file ever gets regenerated/reset.
