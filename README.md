# dotfiles

https://github.com/bernardolm/dotfiles

Terminal environment bootstrap for macOS, WSL (Ubuntu), Ubuntu Server, and Termux.

## Goals
- Same shell experience across environments
- Minimal maintenance, portable, Python-first bootstrap
- Separate terminal config from container recipes

## What this repo configures
Common (all environments):
- zsh
- zimfw
- starship
- tmux
- nano
- git
- python3
- ssh

macOS + WSL:
- wezterm
- delta
- tldr
- go
- vscode

macOS + WSL + Ubuntu Server:
- ripgrep
- fzf
- docker

Ubuntu Server:
- vscode tunnel server (manual step, see below)

## Structure
- terminal/: shell, prompt, and terminal app configs
- containers/: docker recipes (keep separated from terminal setup)
- bootstrap/: Python bootstrap and linker

## Quick start
1) Clone into `~/dotfiles`
2) Run:

```sh
python3 bootstrap/bootstrap.py --all
```

Use `--profile server` for Ubuntu Server:

```sh
python3 bootstrap/bootstrap.py --all --profile server
```

Dry run:

```sh
python3 bootstrap/bootstrap.py --all --dry-run
```

## Notes
- wezterm on WSL is expected to be installed on the Windows host. The config is in `terminal/wezterm/wezterm.lua`.
- delta config is linked only on macOS/WSL. On other platforms it is ignored.
- zimfw is installed via git if missing.
- vscode tunnel server: run `code tunnel` after VS Code CLI is installed.
- ssh config enables multiplexing to keep long sessions fast and stable. tmux is the default tool for long-running tasks.
- set your git user.name and user.email in `terminal/git/gitconfig` or add a local override.
- the repo is referenced as `$HOME/dotfiles`; `.zshenv` creates a symlink to the real clone if needed.

## Local overrides
Place extra zsh config in `terminal/zsh/zshrc.d/*.zsh`.

## Command helpers
All helper functions from the bootstrap are available as CLI commands in `bin/` and added to your PATH by `.zshrc`.

## Platform configs
Each platform has a `bootstrap/<platform>/config.yml` file that drives platform-specific installs.
The `bootstrap/sample.config.yml` file is the template for those configs.
