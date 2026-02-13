# dotfiles

Dotfiles para uso em 3 ambientes:
- macOS desktop (WezTerm + zsh)
- Windows 11 desktop (Windows Terminal + PowerShell)
- Linux server (zsh em perfil `server`)

## bootstrap

O fluxo principal está em `bootstrap/bootstrap.py` e auto-detecta o SO.

```bash
python3 bootstrap/bootstrap.py --all
```

Perfis disponíveis:
- `desktop`: inclui setup de terminal gráfico (ex.: WezTerm em Unix)
- `server`: prioriza shell e utilitários de servidor

Também é possível forçar:

```bash
python3 bootstrap/bootstrap.py --all --profile desktop
python3 bootstrap/bootstrap.py --all --profile server
```

## seleção de config

Para cada plataforma, o bootstrap resolve o arquivo nessa ordem:
- `bootstrap/<platform>/<hostname>.<profile>.config.yml`
- `bootstrap/<platform>/<hostname>.config.yml`
- `bootstrap/<platform>/<profile>.config.yml`
- `bootstrap/<platform>/config.yml`

Você pode sobrescrever host e config por entrypoint de plataforma:

```bash
python3 bootstrap/ubuntu/bootstrap.py --profile server --host proxmox
python3 bootstrap/windows/bootstrap.py --config bootstrap/windows/config.yml
```

## comportamento por sistema

- macOS: linka zsh + starship + git + ssh + WezTerm (perfil `desktop`)
- Windows: aplica `terminal/windows-terminal/settings.json` e `terminal/powershell/Microsoft.PowerShell_profile.ps1` quando o Windows Terminal é detectado
- Linux server: evita link de WezTerm e usa pacote/config focado em shell e operação remota

## estrutura

- `bootstrap/`: tudo de instalação e provisionamento
- `terminal/`: configuração de shell e terminais
- `bin/`: utilitários do repositório
