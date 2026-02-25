# dotfiles

Dotfiles repository to keep a consistent terminal environment across macOS, Windows (PowerShell + WSL), Ubuntu/Debian server, and Alpine, with as much sharing as possible.

## what this repository configures

- shell: `zsh` (primary), `ash` (alpine), and `powershell` (windows);
- prompt: `starship`;
- terminal: `wezterm` and `windows terminal`;
- tools: `git`, `ssh`, `tmux`, `nano`, and terminal utilities;
- platform bootstrap in `bootstrap/`.

## quick usage

Prerequisite: clone into `~/dotfiles`.

```bash
cd ~/dotfiles
python3 bootstrap/bootstrap.py
```

Useful modes:

```bash
DOTFILES_DRY_RUN=1 python3 bootstrap/bootstrap.py
DOTFILES_BOOTSTRAP_LINK=0 python3 bootstrap/bootstrap.py
DOTFILES_BOOTSTRAP_INSTALL_PACKAGES=0 python3 bootstrap/bootstrap.py
DOTFILES_PROFILE=server python3 bootstrap/bootstrap.py
```

## main structure

- `bootstrap/`: installation and configuration by platform/profile.
- `terminal/`: shell, prompt, terminal, and tooling files.
- `.githooks/`: repository quality automations (pre-commit).
- `bin/`: helper utilities.
- `.v1/`: legacy version for reference only.
