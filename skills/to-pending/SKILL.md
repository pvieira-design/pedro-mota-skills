---
name: to-pending
description: Record a deferred loose end as a GitHub issue labelled `pending`, or resume/resolve an existing pending issue. Use when work is deliberately postponed, an edge case or debt must not be forgotten, the user says to revisit something later, or asks to resume or close a pending item.
---

Manage deferred work in GitHub Issues. A pending item is an open issue labelled `pending`, without an assignee or any `ready-*` label. It is remembered but remains outside the execution frontier.

This skill writes to GitHub. Run it only when the user explicitly asks to record, resume, or resolve deferred work, or explicitly confirms that a stated deferral should be recorded.

The current session chat and internal Orca messages are approved channels for sensitive values needed by the task. GitHub is external: a pending issue may contain only non-sensitive consequences or safe references, never secrets, credentials, PII or raw sensitive payloads. Do not block or invent an indirect handoff merely because the value must move between the two approved channels.

Choose the mode from the argument:

- `resume <issue>` or `promote <issue>` → **RESUME**;
- `done <issue>` or `resolve <issue>` → **RESOLVE**;
- anything else → **RECORD**.

## Grounding

1. Confirm the repository with `gh repo view --json nameWithOwner` and infer it from the current checkout.
2. Confirm GitHub authentication with a read operation.
3. Read `docs/agents/issue-tracker.md` when present and follow its repository-specific conventions.
4. Confirm the `pending` label exists. If absent, create it with color `D4C5F9` and description `Deferred loose end to revisit; not ready for execution`. If the existing label has an incompatible meaning, stop and ask before changing it.

There is no markdown fallback. If GitHub is unavailable, report the blocker without writing under `docs/pending/`.

## RECORD

### 1. Define one loose end

Use the request and conversation context to identify exactly one deferred item. For multiple independent items, create one issue per item. Ask a short question only when the scope, reason, or impact cannot be recovered safely.

### 2. Avoid duplicates

Search open `pending` issues and other open issues for the same responsibility. When an equivalent issue exists, add missing context as a comment and return its URL instead of creating another issue.

### 3. Create a self-sufficient issue

Use a concrete title without a `[Pending]` prefix; the label carries the state. Create the issue with only the `pending` label. Do not assign it or add `ready-for-agent`, `ready-for-human`, `needs-triage`, `plan`, or `spec`.

Use this body:

```markdown
## O que ficou pendente

<concrete loose end>

## Por que foi adiado

<scope, dependency, missing decision, or timing reason>

## Impacto se continuar pendente

<affected behavior, risk, and urgency>

## Próximo passo sugerido

<first action, file, question, or owner needed to resume>

## Referências

<issue, ADR, feature doc, commit, or code paths>

## Registro

- Data: YYYY-MM-DD
- Área: <feature/domain>
- Prioridade: <alta|média|baixa>
```

Every section must contain useful, verified context. Reference canonical docs instead of copying them.

### 4. Verify and report

Read the created issue back. Completion means it is open, has exactly the intended body, carries `pending`, has no assignee, and has no `ready-*` label. Return its number and URL.

## RESUME

1. Resolve the issue number from the argument. When absent, list open issues labelled `pending` and ask which one.
2. Read the issue and comments. Require it to be open and labelled `pending`.
3. Comment with the reason it is being resumed and the immediate next triage question or action.
4. Remove `pending` and add `needs-triage`. Create `needs-triage` only when missing and when repository conventions do not map that role to another label.
5. Leave it unassigned and without `ready-*`; normal triage decides its next state.
6. Read it back and report the URL.

## RESOLVE

1. Resolve the issue number from the argument. When absent, list open issues labelled `pending` and ask which one.
2. Read the issue and comments. Require it to be open and labelled `pending`.
3. Add a resolution comment stating whether it was implemented elsewhere, superseded, duplicated, or no longer applies, with evidence or links.
4. Close the issue. Keep the `pending` label as historical classification.
5. Read it back and verify that it is closed, then report the URL.

## Boundaries

- Record only; do not implement the deferred work in RECORD mode.
- Keep durable vocabulary in `CONTEXT.md`, architectural decisions in ADRs, present behavior in `docs/system/`, and recurring traps in `docs/learnings/`.
- Treat the existing `docs/pending/` tree as historical archive. Do not create, move, or index files there.
