# Repository Agent Rules

- Ignore completamente a pasta `.v1/` em qualquer tarefa padrão.
- Não ler, buscar, indexar, analisar, formatar, lintar, reparar ou editar arquivos dentro de `.v1/`.
- Não usar conteúdo de `.v1/` como fonte para respostas, refatorações ou documentação.
- Só acessar `.v1/` se houver pedido explícito e direto do usuário para isso.
- Ao executar automações, limitar o escopo a caminhos fora de `.v1/`.
- Para novas automações e scripts: usar Python por padrão.
- Usar shell script apenas quando a tarefa não puder ser feita de forma adequada em Python.
