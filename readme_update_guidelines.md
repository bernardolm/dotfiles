# Diretrizes de Atualizacao do README por IA

Este arquivo define as regras obrigatorias para qualquer ferramenta de IA que atualize `README.md` neste repositorio.

## Objetivo

Atualizar o `README.md` para refletir, com precisao, os commits que estao sendo enviados no `git push`, sem inventar funcionalidades e sem remover informacoes corretas que continuam validas.

## Fontes permitidas

- Commits informados pelo hook de pre-push.
- Arquivos reais do repositorio (`bootstrap/`, `terminal/`, `bin/`, `.githooks/`, `.vscode/`, `platform/`, `containers/`).

Nao usar informacao externa como fonte de verdade para descrever este projeto.

## Regras obrigatorias

- Alterar somente `README.md`.
- Manter o texto em portugues.
- Ignorar completamente a pasta `.v1/` (nao ler, nao usar como referencia e nao citar no README, exceto se o contexto exigir explicar que e um arquivo historico).
- Nao inventar sistemas, ferramentas, comandos ou fluxos nao presentes no repositorio.
- Nao remover secoes uteis sem substituicao equivalente.
- Priorizar clareza para quem nunca viu o projeto.
- Garantir que o README explique os seguintes itens obrigatorios:
1. proposito do repositorio;
2. publico-alvo e cenarios de uso;
3. sistemas operacionais suportados;
4. o que e configurado (shell, terminal, prompt, git, ssh, bootstrap, pacotes);
5. como executar o bootstrap;
6. organizacao de pastas principais;
7. comportamentos relevantes de hooks git.

## Estrutura recomendada

O README deve manter uma estrutura simples e direta, cobrindo pelo menos:

- Visao geral
- Sistemas e ambientes suportados
- O que o repositorio configura
- Bootstrap e instalacao
- Estrutura de diretorios
- Fluxo de documentacao com IA no pre-push

## Estilo de escrita

- Texto objetivo, tecnico e legivel.
- Evitar marketing, exagero e texto generico.
- Preferir listas curtas e exemplos de comando executaveis.

## Validacao antes de finalizar

- Confirmar que comandos e caminhos citados existem no repositorio.
- Confirmar que o README final e coerente com os commits informados.
- Se nao houver mudancas relevantes para documentacao, manter alteracoes minimas.
