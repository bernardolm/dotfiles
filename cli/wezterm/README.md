# WezTerm

## Reference and copyleft

- <https://alexplescan.com/posts/2024/08/10/wezterm>
- <https://gist.github.com/alexpls/83d7af23426c8928402d6d79e72f9401>

## Install

```sh
brew install lua luarocks wezterm
luarocks install inspect
```

## SSH pede senha mesmo com a chave no 1Password

```sh
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist
```

Se persistir: item errado do 1Password mapeado pro host. Corrige no app,
ou fixa via `Host <nome>` em `~/.ssh/config`, antes do `Include`.

## `~/.ssh/authorized_keys`

Tem que ser arquivo local real, não symlink pro Dropbox/CloudStorage —
`sshd-session` (sandbox do macOS) não lê. Atualiza manual.

## Manter `wezterm-mux-server` sempre ligado (opcional)

```sh
mkdir -p ~/Library/LaunchAgents
ln -sf ~/dotfiles/cli/wezterm/com.wezterm.mux-server.plist ~/Library/LaunchAgents/
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.wezterm.mux-server.plist
```
