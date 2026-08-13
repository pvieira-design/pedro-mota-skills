---
name: to-tickets
description: Decompose an approved GitHub `spec` issue into executable tracer-bullet child issues with exact criterion ownership and native dependencies. Use when the user explicitly asks to publish tickets from a spec; reject conversations, grills, Wayfinder maps and local plans.
---

# To Tickets

Turn one approved `spec` into its executable queue. The user's explicit request to create or publish tickets authorizes the tracker mutations and the decomposition choices; do not add an intermediate approval ritual.

## 1. Validate the source

Require the URL or number of an open, unassigned issue labelled `spec` and carrying no `ready-*` label. Read its full body and comments, repository instructions, tracker protocol, linked durable docs and current code anchors.

Refuse every other input: loose conversation, `grill:session`, `wayfinder:map`, Wayfinder decision ticket, local plan or local grill. Stop without mutation if the spec contains a placeholder, contradiction, blocking choice, unverifiable criterion or missing contract.

The current session chat and internal Orca messages are approved channels for sensitive values needed by the work. GitHub child issues are external: carry only non-sensitive consequences, guardrails or safe references, never secrets, credentials, PII or raw sensitive payloads.

## 2. Design and self-review the queue

Create one narrow, complete tracer-bullet child per independently verifiable behavior. Each child:

- delivers observable end-to-end behavior through the required layers;
- fits one fresh implementation session;
- owns a unique subset of the spec's acceptance criteria;
- declares real blocking edges;
- includes exact verification commands and invariants;
- is AFK (`ready-for-agent`) or names the precise HITL checkpoint (`ready-for-human`).

Use expand → migrate batches → contract only for mechanical wide refactors that cannot land as ordinary vertical slices.

Before mutation, self-review both directions: **every positive criterion and every negative restriction in the spec belongs to exactly one child's criterion, invariant or explicit out-of-scope boundary, and every child traces to the spec**. Resolve operational choices such as ticket count, titles, boundaries, order and blockers autonomously. Stop only when the spec itself needs a product, scope or architecture decision.

## 3. Publish in two passes

Keep the existing spec as the non-executable parent. Do not create a `plan` root.

1. Create every child and attach it directly to the spec with native sub-issue relationships.
2. After identifiers exist, add native blocking dependencies. Use textual `Blocked by` only when the tracker lacks native support.

```markdown
## Source of truth

- Parent spec: #<number> → <section/criteria>
- Feature docs: <links>
- ADRs/learnings: <links>

## What to deliver

<observable end-to-end behavior>

## Mode

AFK | HITL: <exact checkpoint>

## Acceptance criteria

- [ ] <atomic criterion owned only by this issue>

## Verification

- `<exact focused command>`

## Invariants

- <what must not break or change>

## Blocked by

- <native references or None>
```

Verify the resulting frontier: open, unassigned `ready-for-agent` children with no open blocker. Comment the published coverage summary on the spec.

## 4. Report

Return the spec and child links by title, dependency/frontier state, mode and criterion coverage. The next step is one fresh `implement` session per frontier issue.
