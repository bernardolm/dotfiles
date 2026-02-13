# Diretrizes de Atualizacao do README por IA

Este arquivo define as regras obrigatorias para qualquer ferramenta de IA que atualize `README.md` neste repositorio.

## Objetivo

Gerar atualizacao incremental para o `README.md`, refletindo com precisao apenas os commits que estao sendo enviados no `git push`, sem reescrever o documento inteiro.

## Fontes permitidas

- Commits informados pelo hook de pre-push.
- Arquivos reais do repositorio (`bootstrap/`, `terminal/`, `bin/`, `.githooks/`, `.vscode/`, `platform/`, `containers/`).

Nao usar informacao externa como fonte de verdade para descrever este projeto.

## Regras obrigatorias

- Alterar somente `README.md`.
- Manter o texto em portugues.
- Ignorar completamente a pasta `.v1/` (nao ler, nao usar como referencia e nao citar no README, exceto se o contexto exigir explicar que e um arquivo historico).
- Nao inventar sistemas, ferramentas, comandos ou fluxos nao presentes no repositorio.
- Nao reescrever secoes existentes fora da area incremental.
- Nao remover secoes uteis sem substituicao equivalente.
- Priorizar atualizacoes objetivas e focadas no delta dos commits.
- Nao reexplicar o projeto inteiro; focar apenas no que os commits trazem de novo/relevante.
- Nao criar commit.

## Estrutura recomendada

As atualizacoes devem ser adicionadas na secao incremental gerenciada pelo hook:

- `## atualizacoes incrementais (pre-push IA)`
- bloco delimitado por:
	- `<!-- docs-ai-updates:start -->`
	- `<!-- docs-ai-updates:end -->`

Nao alterar a estrutura principal do README, exceto quando estritamente necessario.

## Estilo de escrita

- Texto objetivo, tecnico e legivel.
- Evitar marketing, exagero e texto generico.
- Preferir listas curtas.
- Resumo curto, no formato de bullets.
- Evitar repeticao do que ja esta documentado no restante do README.

## Formato de saida obrigatorio

- Responder somente em markdown.
- Nao usar titulo de nivel 1/2/3.
- Nao usar bloco de codigo.
- No maximo 6 bullets.
- Cada bullet com no maximo 1 linha.

## Validacao antes de finalizar

- Confirmar que comandos e caminhos citados existem no repositorio.
- Confirmar que a atualizacao incremental e coerente com os commits informados.
- Se nao houver mudancas relevantes para documentacao, retornar exatamente `SKIP`.
