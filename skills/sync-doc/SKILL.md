---
name: sync-doc
description: Sincronizar a documentação técnica viva de uma feature com o código real, criando o feature-doc quando ausente ou corrigindo divergências quando existente. Usar ao terminar ou ajustar uma feature, quando o usuário pedir `/sync-doc`, "atualize a documentação técnica", "confira se docs/system bate com o código" ou antes de fechar um plano implementado.
---

# Sync Doc

Sincronizar somente a documentação do estado atual do sistema. Não alterar código de produto, não escrever plano futuro e não transformar pendências ou aprendizados em regras já implementadas.

## 1. Carregar as convenções do projeto

1. Ler `AGENTS.md` e, se existir, `CLAUDE.md`.
2. Se existir uma instrução local em `.agents/skills/sync-doc/SKILL.md`, `.codex/skills/sync-doc/SKILL.md` ou `.claude/commands/sync-doc.md`, aplicar as regras específicas do projeto sem ignorar instruções de maior prioridade.
3. Localizar, preferencialmente em paralelo:
   - `docs/system/`
   - `docs/features/`
   - `docs/architecture/`
   - `docs/`
   - `documentation/`
   - arquivos `_template.md` ou `TEMPLATE.md`
   - índices e mapas de feature em `docs/system/README.md`, `AGENTS.md` e `CLAUDE.md`
4. Usar `docs/system/` quando existir. Se o projeto não tiver convenção de documentação por feature, informar isso e recomendar `$setup-pedro-mota` ou pedir o diretório de destino.

No CRM, obedecer especialmente ao fluxo obrigatório descrito no `AGENTS.md`: começar pelo mapa de `docs/system/README.md`, ler o feature-doc, ADRs, `CONTEXT.md`, learnings e pending relevantes antes de comparar com o código.

## 2. Identificar a feature

Se o usuário informou a feature, usar esse nome e confirmar a correspondência no índice canônico.

Caso contrário, inspecionar em paralelo:

- `git status --short`
- `git diff --stat`
- `git diff --name-only`
- `git log --oneline -10`

Relacionar os paths alterados ao mapa do projeto. Se várias features independentes foram tocadas ou a correspondência continuar ambígua, pedir ao usuário qual delas deve ser documentada. Não escolher silenciosamente.

Preservar alterações não relacionadas já presentes no working tree.

## 3. Escolher CREATE ou UPDATE

- Documento existente: seguir **UPDATE**.
- Documento ausente: seguir **CREATE**.

### UPDATE

1. Ler integralmente o documento atual.
2. Ler os arquivos de código que sustentam suas afirmações: rotas, routers, handlers, schemas, telas, componentes centrais, workers e integrações.
3. Comparar afirmação por afirmação:
   - procedures, endpoints, inputs e gates de permissão;
   - paths e nomes de arquivos;
   - modelos, tabelas, colunas, enums e índices;
   - regras de negócio, TTLs, limites, validações e ordem de execução;
   - helpers, funções, variáveis de ambiente e integrações externas;
   - estados de frontend e fluxos e2e afetados.
4. Apresentar divergências concretas antes de editar, com linha ou seção, valor atual e correção proposta.
5. Aplicar após a confirmação do usuário quando a skill tiver sido invocada apenas para auditoria. Se o pedido já autorizar explicitamente atualizar/corrigir a documentação, aplicar diretamente.
6. Atualizar `## Última atualização` com a data e o motivo real da mudança.

### CREATE

1. Ler e seguir o template do projeto.
2. Mapear no código:
   - telas e rotas;
   - procedures/handlers, inputs e gates;
   - persistência e índices;
   - libs e helpers centrais;
   - componentes principais;
   - worker, filas e integrações externas.
3. Preencher somente com nomes reais comprovados no repositório.
4. Perguntar ao usuário apenas regras de negócio ou motivos que não possam ser inferidos do código ou das decisões documentadas. Fazer perguntas específicas.
5. Criar o feature-doc e atualizar todos os índices exigidos pelo projeto. No CRM, adicionar a feature ao "Mapa por assunto" e à lista de documentos em `docs/system/README.md`.

## 4. Estrutura de fallback

Usar somente quando não houver template:

```markdown
# <Feature>

## Última atualização

AAAA-MM-DD — <motivo real>

## O que é

<descrição curta>

## Onde fica

- Tela/rota: `path`
- Backend: `path`
- Schema: `path`

## API / procedures

- `procedure(input)` — gate: `<permissão>` — finalidade

## Regras de negócio

- ...

## Dependências externas

- ...

## Arquivos-chave

- `path` — papel
```

## 5. Validação obrigatória

Antes de concluir:

- Confirmar que cada arquivo citado existe.
- Confirmar com `rg`/`git grep` cada procedure, handler, função, tabela e enum citado.
- Remover placeholders e exemplos do template.
- Garantir data e motivo real em `Última atualização`.
- Atualizar documentos de outras features quando uma mudança compartilhada também as afetar.
- Em documento novo, atualizar todos os índices exigidos.
- Confirmar que endpoints e routers estão registrados, não apenas declarados.
- Se o fluxo tiver e2e coberto, conferir se o spec continua coerente; não alterar o teste nesta skill.
- Rodar checagens de links/formatos disponíveis no repositório.
- Revisar `git diff -- <paths-de-doc>` e garantir que nenhum código de produto foi alterado.

Se faltar contexto humano, registrar explicitamente sem inventar:

```markdown
- TODO(sync-doc AAAA-MM-DD): confirmar <pergunta específica>.
```

## 6. Encerramento

Responder de forma curta com:

- `CREATE` ou `UPDATE`;
- documento e path;
- linha de última atualização;
- validações executadas;
- eventual pergunta ou TODO pendente.

Se a feature veio de um plano em `docs/plans/`, lembrar de usar `$to-plan` em modo `done` somente depois que implementação, testes e documentação estiverem concluídos.

Se surgir uma armadilha não óbvia que custou tempo e pode se repetir, oferecer `$to-pending` ou o registro em `docs/learnings/`, conforme a convenção do projeto. Não criar esses registros automaticamente sem que o escopo autorize.
