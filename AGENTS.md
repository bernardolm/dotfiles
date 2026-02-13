# Repository Agent Rules

- Ignore completamente a pasta `.v1/` em qualquer tarefa padrao.
- Nao ler, buscar, indexar, analisar, formatar, lintar, reparar ou editar arquivos dentro de `.v1/`.
- Nao usar conteudo de `.v1/` como fonte para respostas, refatoracoes ou documentacao.
- So acessar `.v1/` se houver pedido explicito e direto do usuario para isso.
- Ao executar automacoes, limitar o escopo a caminhos fora de `.v1/`.
- Para novas automacoes e scripts: usar Python por padrao.
- Usar shell script apenas quando a tarefa nao puder ser feita de forma adequada em Python.
- Nao recriar em Python os shell scripts antigos ja existentes (regra valida apenas para novos codigos).
- Quando for realmente necessario criar um novo script shell, incluir justificativa tecnica no proprio arquivo com o marcador `shell-required:`.
