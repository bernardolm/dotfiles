# SayoDevice O3C PP — setup

Teclado macro de 4 teclas (Z/X/C/V) com tela OLED 160x80, configurado via
https://sayodevice.com (app web que fala com o dispositivo por WebHID, Chrome only).

## Como replicar em outra máquina

1. Conectar o O3C via USB.
2. Abrir https://sayodevice.com no Chrome, clicar "Add device" e escolher o
   O3C PP no popup de pareamento HID do navegador.
3. Restaurar a config real do device: no app web, menu > "Backup & Restore" >
   "Restore" > selecionar `sayo-o3c-pp-backup.sayobak` deste diretório >
   Confirm. Isso traz Binding, Screen (Bootup/Main), Light, Images e tudo mais
   de uma vez — não precisa reconfigurar manualmente (a seção "Config do
   device" abaixo é só referência/histórico, caso o restore falhe ou for
   parcial).
4. Copiar `hammerspoon-init.lua` (ou fazer merge) pro `~/.hammerspoon/init.lua`
   local e reiniciar o Hammerspoon (`killall Hammerspoon && open -a Hammerspoon`).
5. Copiar `gopher-boot-160x80.png` se quiser reconfigurar a imagem de boot do
   zero (Screen > Bootup > layer Custom Images, ver notes).

## Estrutura

- `sayo-o3c-pp-backup.sayobak` — export oficial via "Backup & Restore" do app
  web, com toda a config do device (Binding, Screen, Light, Images, etc). É o
  arquivo pra usar num restore rápido; as seções abaixo são a documentação
  legível do que tem dentro dele.
- `hammerspoon-init.lua` — cópia do `~/.hammerspoon/init.lua` com os 4 hotkeys
  do teclado (a parte relevante pro O3C; o resto do arquivo real do usuário
  pode ter mais coisas).
- `gopher-boot-160x80.png` — imagem do gopher Go usada na tela de boot.

## Resumo rápido do mapeamento

| Tecla | Combo enviado (macOS)     | Ação                                              | Cor pretendida (LED, não suportado) |
|-------|---------------------------|----------------------------------------------------|--------------------------------------|
| Z     | Ctrl+Option+Cmd+1         | Abre/foca Docker Desktop                           | Ciano                                |
| X     | Ctrl+Option+Cmd+2         | Abre/foca WezTerm                                  | Magenta                              |
| C     | Ctrl+Option+Cmd+3         | Roda `~/sync/personal/vpn/acao/openvpn.sh`         | Vermelho                             |
| V     | Ctrl+Option+Cmd+4         | Abre/foca Claude Desktop                           | Laranja                              |

**Por que Ctrl+Option+Cmd+N e não F13/F14/F15?** Tentativa inicial usou F13/F14/F15
(teclas "de sobra" sem uso padrão). Só que no MacBook Air M4, F14/F15 são
reservadas pelo macOS pro brilho da tela (diminuir/aumentar) — o SO intercepta
antes do Hammerspoon conseguir ver o evento, matando o hotkey silenciosamente.
Solução: usar um "hyperkey" chord (Ctrl+Option+Cmd + dígito) que não tem
nenhum uso reservado pelo sistema.

## LED por tecla — não funciona nesse hardware

Tentamos (nessa ordem):
1. UI oficial: Configuration > Light > selecionar tecla > mudar cor > Save.
   Não mudou nada fisicamente, mesmo com Save completo (grava na flash do
   device).
2. Engenharia reversa do protocolo HID: hookamos `HIDDevice.prototype.sendReport`
   no Chrome (já que o app já tem permissão WebHID concedida) pra capturar os
   bytes reais mandados quando a cor é editada na UI. Achamos reportId 34,
   payload de 1023 bytes, com padrão: byte[6] = índice da tecla (0-3),
   bytes[27..29] = RGB. Só que Save é o único jeito de aplicar (grava na
   flash — lento, sem canal "live" pra update instantâneo), e mesmo assim o
   Save não mudou o LED físico.

Conclusão: essa variante "O3C PP" provavelmente não tem LED RGB por tecla —
só a tela OLED (o "Light" na UI pode ser um recurso genérico do firmware
compartilhado com outros modelos da linha que têm luz, mas que essa unidade
não tem fisicamente). Se descobrir o contrário (alguma luz física em algum
canto acende quando mexe no Light), voltar a investigar — os bytes do
protocolo já estão documentados acima como ponto de partida.

## Screen (tela OLED 160x80)

- **Bootup**: layer #0 = Type "Custom Images", a imagem `gopher-boot-160x80.png`
  (gopher da linguagem Go, fundo preto, 160x80, ajustada a partir da imagem
  oficial do blog do Go).
- **Main** (tela normal de uso): 
  - layer #0: Pure Color preto, X=0 Y=0, Width=160 Height=80 (fundo full-screen,
    necessário pra imagem do boot não "vazar"/persistir visualmente na tela
    principal).
  - layer #1: ASCII Texts "Docker", cor ciano `#00FFFF`, Background off,
    posição X=45 Y=2.
  - layer #2: ASCII Texts "WezTerm", cor magenta `#FF00FF`, Background off,
    posição X=45 Y=20.
  - layer #3: ASCII Texts "VPN", cor vermelha `#FF0000`, Background off,
    posição X=45 Y=39.
  - layer #4: ASCII Texts "Claude", cor laranja `#FFA500`, Background off,
    posição X=45 Y=58.
  - layer #9: Type "Widget" > sub-type "Key State (Vertical)", Position X=0
    Y=0, Background off, Text color branco `#FFFFFF` — mostra o estado das 4
    teclas fisicamente pressionadas, do lado esquerdo da tela.
  - demais layers (#5-8, #10+): None (limpas, sem uso).

Tudo isso já está salvo no device e no `sayo-o3c-pp-backup.sayobak`.

## Binding (Configuration > Binding > Fn0)

Cada tecla: Key Mode = "Keyboard", campo customizado (aberto pelo ícone de
teclado no editor), modo "Linux/Mac" selecionado no picker, teclas: control +
option(alt) + command + dígito 1/2/3/4 conforme a tabela acima.

## Hammerspoon

Ver `hammerspoon-init.lua`. Pontos de atenção:
- Precisa reiniciar o Hammerspoon (`killall Hammerspoon && open -a Hammerspoon`)
  depois de editar `init.lua` pra pegar a config nova (o CLI `hs -c` não
  funcionou nessa máquina — falta o módulo `ipc`; reinício manual do processo
  resolve).
- Docker Desktop precisa do path completo do bundle, não do nome curto:
  `/Applications/Docker.app/Contents/MacOS/Docker Desktop.app` — o app real
  fica aninhado dentro do `Docker.app` visível no Launchpad.
