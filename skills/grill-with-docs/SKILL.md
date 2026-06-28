---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, records the interrogation in docs/grills/ (one file per topic, find-or-create), and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

Then layer the domain and documentation awareness below on top of that interview.

Throughout, keep a durable **record of the session** in `docs/grills/` (see "Session record" below): find-or-create the topic's file at the start, and capture decisions and the Q&A trail inline as you go — so the context is never lost.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## Session record — `docs/grills/`

Every grilling session is recorded in `docs/grills/`, the **memory of the interrogation**: the closed decisions, the trail of questions and the answers given, the hypotheses dropped, and what's still open. This is the durable record so the context survives between sessions and a future reader sees not just *what* was decided but *how* you got there. It's upstream of `CONTEXT.md` (vocabulary), `docs/adr/` (one hard decision), and `docs/plans/` (the plan) — what crystallises here flows out to those, with a pointer back.

### Find-or-create at the start (one file per topic)

A grill doc is keyed by **topic**, not by date. Before interrogating, look in `docs/grills/` for an existing file on the same topic:

- **It already exists** → **edit** it: append a new session entry stamped with the date/time, and refresh its "Still open" agenda. Re-grilling the same topic accumulates history in one file.
- **It doesn't exist** → **create** it from the topic's slug (e.g. `checkout-flow.md`).

If `docs/grills/` doesn't exist yet, create it lazily when you write the first session (same as `CONTEXT.md`/`docs/adr/`).

### Capture inline, not batched

As the session unfolds, write into the topic's file **as decisions crystallise** — don't reconstruct it at the end. For each session entry record: the focus, the **closed decisions** (with their why, and where they flowed to — ADR/`CONTEXT.md`/plan), the **Q&A trail** (the question and the answer the user gave), **dropped hypotheses** (and why), and what was **left open**. Use the grills template/README seeded by `/setup-pedro-mota` for the exact structure.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, update `CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` should be totally devoid of implementation details. Do not treat `CONTEXT.md` as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
