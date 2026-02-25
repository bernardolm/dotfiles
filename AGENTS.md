# Repository Agent Rules

- Ignore completamente a pasta `.v1/` em qualquer tarefa padrão.
- Não ler, buscar, indexar, analisar, formatar, lintar, reparar ou editar arquivos dentro de `.v1/`.
- Não usar conteúdo de `.v1/` como fonte para respostas, refatorações ou documentação.
- Só acessar `.v1/` se houver pedido explícito e direto do usuário para isso.
- Ao executar automações, limitar o escopo a caminhos fora de `.v1/`.
- Para novas automações e scripts: usar Python por padrão.
- Usar shell script apenas quando a tarefa não puder ser feita de forma adequada em Python.
- Para `bin/vscode_profile.py`: não adicionar argumentos de CLI. A execução deve ser `./bin/vscode_profile.py` e a saída deve conter somente o nome do profile ativo do VS Code.

## Regras para pedidos de git commit

Quando o usuário pedir apenas para "fazer git commit", seguir sempre estas regras:

- Fazer commit apenas do que já está no git stage, sem acrescentar nem remover arquivos do stage.
- Nunca alterar o conteúdo dos arquivos que já estão no stage e adicionar novamente ao stage.
- Nunca mexer em mudanças fora do stage (working tree/HEAD fora do stage).
- Sempre escrever uma mensagem de commit descrevendo as alterações presentes somente no stage.
- Sempre escreva as mensagens do commit em inglês americano en-US.
