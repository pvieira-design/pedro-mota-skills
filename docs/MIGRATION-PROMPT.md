# Prompt para atualizar projetos que já receberam a documentação antiga

Copie o bloco abaixo em uma nova conversa aberta na raiz do projeto:

```text
Atualize este repositório para a versão atual do workflow Pedro Mota + Matt Pocock, preservando conteúdo válido e sem alterar código de produto.

Objetivo

Corrigir a arquitetura de documentação, skills e instruções do projeto para funcionar de forma coerente no Claude Code e no Codex, sem duplicar memória nem instalar a mesma skill em dois escopos.

Antes de editar

1. Leia integralmente AGENTS.md, CLAUDE.md, CONTEXT.md e docs/agents/ existentes.
2. Abra docs/system/README.md e os feature-docs relevantes para entender como a documentação atual está organizada.
3. Inspecione docs/adr/, docs/learnings/, grills/mapas/specs/tickets no GitHub e issues abertas com label `pending`. Trate qualquer `docs/plans/`, `docs/grills/` ou `docs/pending/` existente como arquivo histórico.
4. Rode `npx skills list --json` e `npx skills list --global --json` para detectar skills homônimas instaladas simultaneamente no projeto e no usuário.
5. Mostre um diagnóstico curto do que já está correto, do que está defasado e do que pretende mudar. Preserve alterações alheias.

Regras a implementar

1. Memória canônica do projeto/features
   - docs/system/ é a documentação técnica viva do que o código faz HOJE e a primeira fonte para entender uma feature.
   - CONTEXT.md guarda vocabulário; docs/adr/ guarda o porquê durável; GitHub Issues com label `spec` guardam o futuro aprovado; issues com label `pending` guardam pontas adiadas; docs/learnings/ guarda armadilhas recorrentes.
   - A issue GitHub `grill:session` é a memória operacional de uma sessão explícita e avulsa de grill-with-docs; docs/grills/ é arquivo histórico.

2. Grill avulso vs Wayfinder
   - Depois do grounding, grill-with-docs primeiro prova que existe ao menos uma decisão genuína aberta. Só então cria `[Grill] <tópico específico>` com `grill:session` + `ready-for-human` antes da primeira pergunta substantiva. Zero decisões abertas significa zero grill.
   - Wayfinder usa issue-mapa, tickets de decisão e comentários de resolução. Nenhum fluxo cria grill local.
   - to-spec exige pedido explícito de publicação e aceita brief direto decision-complete, grill concluído ou mapa resolvido. Para origem no tracker, lê corpo, comentários e artefatos; para brief direto, exige o contrato completo na sessão atual. Nunca cria grill vazio como plumbing.
   - Resultados duráveis de ambos fluem para CONTEXT.md, ADRs e a spec no GitHub. docs/system/ só muda depois que o código correspondente mudar.

3. Hard gate antes de perguntar ou mapear
   - Antes da primeira pergunta de grill-with-docs ou Wayfinder, e antes da primeira mutação do Wayfinder no tracker, ler docs/system/README.md, o feature-doc alvo e os feature-docs adjacentes/complementares; depois CONTEXT.md, ADRs, learnings, specs/tickets e pending relevantes.
   - Resumir fatos estabelecidos, seams existentes e dúvidas genuínas.
   - Não perguntar ao usuário fatos que docs ou código respondem; levar ao usuário somente decisões de produto/design.

4. Fluxo operacional
   - Trabalho simples e decidido: implementação direta.
   - Brief decision-complete que precisa de contrato AFK: to-spec direto.
   - Decisão delimitada aberta: grill-with-docs → to-spec.
   - Planejamento multissessão com fog real: wayfinder → tickets de research/prototype/grilling/task → to-spec.
   - Spec aprovada: to-tickets cria sub-issues verticais com bloqueios nativos, usando a spec existente como raiz não executável.
   - Implementação: uma issue `ready-for-agent`, aberta, sem assignee e sem blocker por sessão limpa; implement deve se atribuir antes de editar.
   - Fechamento: TDD/checks focados → commit local por paths explícitos → code-review desde o SHA inicial → correções/rechecks → sync-doc → revisão final conjunta de código e docs → provas por critério → fechamento dos tickets e da spec.
   - Não fazer push sem autorização explícita. Handoff continua como alternativa de passagem direta quando uma fila no tracker não fizer sentido.

5. Labels do tracker
   - Verifique e crie somente as labels ausentes: `grill:session`, `spec`, `wayfinder:map`, `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, `wayfinder:task`.
   - Verifique também: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix` (ou o mapeamento documentado pelo projeto).
   - Não sobrescreva silenciosamente cor/descrição de label existente e não crie label duplicada.

6. AGENTS.md e CLAUDE.md
   - AGENTS.md é a fonte compartilhada de instruções do projeto.
   - CLAUDE.md deve começar com `@AGENTS.md` e conter abaixo apenas instruções realmente específicas do Claude.
   - Se ambos hoje duplicam o mesmo conteúdo, mantenha a versão compartilhada completa em AGENTS.md e reduza CLAUDE.md ao import + extras específicos.
   - Mantenha o resumo obrigatório no AGENTS.md e o manual detalhado em docs/agents/engineering-workflow.md.

7. Escopo das skills
   - Skills reutilizáveis devem ficar instaladas uma vez no escopo global: `~/.agents/skills` como cópia canônica; Claude aponta para a mesma origem em `~/.claude/skills`; Codex descobre `~/.agents/skills`.
   - Não mantenha a mesma skill simultaneamente em `~/.agents/skills/<nome>` e `<repo>/.agents/skills/<nome>`, pois o Codex mostra “Pessoal” e “Projeto” separadamente.
   - Skill de projeto só fica local quando for realmente específica/pinada por este repo. Antes de remover qualquer cópia local, prove que ela é idêntica à global e que não contém mudanças exclusivas.

8. Dados sensíveis
   - O chat da sessão e mensagens internas do Orca são canais aprovados para segredos, credenciais, PII e payloads sensíveis necessários à tarefa; não recuse nem crie handoff indireto apenas por mover o valor entre esses dois canais.
   - GitHub, arquivos versionados, commits, patches publicáveis e logs públicos são externos: registre somente consequências não sensíveis ou referências seguras, nunca o valor.

Arquivos esperados

- Atualize AGENTS.md e CLAUDE.md conforme acima.
- Atualize/crie docs/agents/engineering-workflow.md, issue-tracker.md, triage-labels.md e workflow-labels.md.
- Remova templates e instruções que criem novos arquivos em docs/grills/; preserve conteúdo antigo apenas como arquivo histórico.
- Atualize qualquer README/índice que ainda descreva docs/grills como superfície operacional.
- Não altere código de produto nesta tarefa.

Validação final

1. Procure referências antigas a “Wayfinder cria grill”, “um grill por tópico”, Click Notes como fila de engenharia, to-tasks/do-task/night-shift e CLAUDE.md duplicando AGENTS.md.
2. Confirme que o hard gate de docs/system aparece nas instruções e no workflow.
3. Confirme as labels no tracker.
4. Confirme com `npx skills list --json` e `npx skills list --global --json` que não há homônimas ativas em dois escopos, ou documente qualquer exceção intencional.
5. Mostre `git diff --stat` e resuma arquivos alterados, validações e qualquer decisão que ainda dependa de mim.
```
