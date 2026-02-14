# dotfiles

Repositório de dotfiles para manter um ambiente de terminal consistente entre macOS, Windows (PowerShell + WSL), Ubuntu/Debian server e Alpine, com o máximo de compartilhamento possível.

## o que este repositório configura

- shell: `zsh` (principal), `ash` (alpine) e `powershell` (windows);
- prompt: `starship`;
- terminal: `wezterm` e `windows terminal`;
- ferramentas: `git`, `ssh`, `tmux`, `nano` e utilitários de terminal;
- bootstrap por plataforma em `bootstrap/`.

## uso rápido

Pré-requisito: clone em `~/dotfiles`.

```bash
cd ~/dotfiles
python3 bootstrap/bootstrap.py
```

Modos úteis:

```bash
DOTFILES_DRY_RUN=1 python3 bootstrap/bootstrap.py
DOTFILES_BOOTSTRAP_LINK=0 python3 bootstrap/bootstrap.py
DOTFILES_BOOTSTRAP_INSTALL_PACKAGES=0 python3 bootstrap/bootstrap.py
DOTFILES_PROFILE=server python3 bootstrap/bootstrap.py
```

## estrutura principal

- `bootstrap/`: instalação e configuração por plataforma/perfil.
- `terminal/`: arquivos de shell, prompt, terminal e ferramentas.
- `.githooks/`: automações de qualidade do repositório (pre-commit).
- `bin/`: utilitários auxiliares.
- `.v1/`: versão antiga apenas para consulta.
