# dotfiles

Repositório para provisionar e manter um ambiente de terminal consistente entre macOS, Windows 11, WSL2 Ubuntu, Linux server (Debian/Ubuntu/Proxmox) e Alpine leve (Raspberry), compartilhando o máximo de configuração possível.

## propósito

Este projeto existe para:

- centralizar configurações de shell, terminal e ferramentas de produtividade;
- reduzir setup manual em máquinas novas;
- manter comportamento previsível entre sistemas diferentes;
- permitir bootstrap por plataforma com ajustes específicos quando necessário.

## o que este repositório configura

- Shell: `zsh` (principal), `ash` (Alpine), `PowerShell` (Windows).
- Prompt: `starship` em todos os ambientes suportados.
- Terminais: `wezterm` (macOS) e `Windows Terminal` (Windows).
- Ferramentas de terminal: `git`, `ssh`, `tmux`, `nano` e utilitários por plataforma.
- Pacotes Go compartilhados via `terminal/go/packages.txt`.
- Pacotes Python compartilhados via `terminal/python/requirements.txt`.
- Bootstrap por sistema operacional em `bootstrap/`.
- Hooks Git em `.githooks/`.

## sistemas e ambientes suportados

- macOS desktop: `wezterm` + `zsh`.
- Windows 11 desktop: `Windows Terminal` + `PowerShell` + WSL2 Ubuntu.
- WSL2 Ubuntu: ambiente de desenvolvimento Linux com `zsh`.
- Linux server headless (Debian/Ubuntu/Proxmox): perfil enxuto com `zsh`.
- Alpine (Raspberry): setup leve com foco em operação essencial e containers.

## visão da estrutura

- `bootstrap/`: fluxo de instalação por plataforma, resolução de perfil e configuração.
- `terminal/`: arquivos de configuração de shell, prompt, terminal e ferramentas CLI.
- `.githooks/`: automações de qualidade e documentação no ciclo de commit/push.
- `bin/`: utilitários auxiliares do repositório.
- `platform/`: anotações e conteúdo de suporte por plataforma.
- `containers/`: stacks e recursos de containers usados no ambiente.
- `.v1/`: snapshot histórico da primeira versão do repositório, somente consulta.

## convenções importantes

- O clone local esperado é `"$HOME/dotfiles"`.
- O bootstrap e os links partem dessa estratégia de path fixo.
- Perfil `desktop` para ambientes com sessão gráfica.
- Perfil `server` para Linux headless.
- Ubuntu usa somente perfil `server`.
- Alpine usa somente perfil `server`.
- `.v1/` deve ser tratado como arquivo histórico: automações, hooks, IA, lint e format devem ignorar esse diretório.

## bootstrap

Fluxo principal (auto-detecção de plataforma):

```bash
python3 bootstrap/bootstrap.py --all
```

Execução por perfil:

```bash
python3 bootstrap/bootstrap.py --all --profile desktop
python3 bootstrap/bootstrap.py --all --profile server
```

Entrypoints diretos por plataforma:

```bash
python3 bootstrap/darwin/bootstrap.py --dry-run
python3 bootstrap/windows/bootstrap.py --dry-run
python3 bootstrap/wsl/bootstrap.py --dry-run
python3 bootstrap/ubuntu/bootstrap.py --profile server --dry-run
python3 bootstrap/alpine/bootstrap.py --profile server --dry-run
```

Resolução de arquivo de config por plataforma:

1. `bootstrap/<platform>/<hostname>.<profile>.config.yml`
2. `bootstrap/<platform>/<hostname>.config.yml`
3. `bootstrap/<platform>/<profile>.config.yml`
4. `bootstrap/<platform>/config.yml`

## estratégia por plataforma

- macOS: pacotes via `brew`, terminal principal `wezterm`, shell `zsh` compartilhado com Linux.
- Windows: apps via `winget`, profile PowerShell centralizado neste repositório.
- WSL/Ubuntu/Server Linux: pacotes via `apt`, shell compartilhado via `zsh`.
- Alpine: pacotes via `pkg/apk`, configuração mais leve para hardware limitado.

## shell e prompt

- `zsh` carrega arquivos em `terminal/zsh/`.
- `PowerShell` (somente Windows) usa `terminal/powershell/Microsoft.PowerShell_profile.ps1`.
- `ash` usa `terminal/ash/.profile`.
- `starship` é usado como prompt padrão quando disponível.
- O bootstrap instala/configura PowerShell apenas no Windows.

## hooks git

Este repositório usa `core.hooksPath=.githooks`.

### pre-commit

- normaliza indentação com tabs nos tipos de arquivo suportados;
- cria `./venv` local quando necessário;
- instala ferramentas Python locais do `requirements.txt` quando ausentes;
- aplica `unimport`, `isort` e `yapf` em arquivos Python staged.
- valida política de novos scripts: Python por padrão; shell apenas com justificativa usando `shell-required:` no topo do novo arquivo.

### pre-push (documentação com IA)

- identifica os commits que serão enviados ao remoto;
- invoca IA para revisar/atualizar `README.md` com base nesses commits;
- usa diretrizes explícitas em `readme_update_guidelines.md`;
- bloqueia o push se `README.md` for alterado pela IA, para revisão e commit antes de reenviar.
- requer um comando de IA disponível no PATH (padrão: `codex`).

Variáveis úteis do fluxo de IA no pre-push:

- `DOTFILES_AI_DOCS_SKIP=1`: pula a etapa de IA no push atual.
- `DOTFILES_AI_DOCS_COMMAND=<cmd>`: altera o comando da ferramenta de IA (padrão: `codex`).
- `DOTFILES_AI_DOCS_TIMEOUT_SECONDS=<segundos>`: timeout da execução da IA.
- `DOTFILES_AI_DOCS_MAX_COMMITS=<n>`: limite de commits considerados no prompt.

## objetivo operacional

Com esse repositório, o objetivo é ter setup reproduzível e manutenção contínua do ambiente de terminal, com customização por sistema sem perder padronização entre máquinas.
