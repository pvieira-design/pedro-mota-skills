# Grilling sessions (`docs/grills/`)

**Memory of the interrogation** — for each topic that got stress-tested in a `/grill-with-docs` (or `/grill-me`) session, one file accumulating everything that was discussed: the closed decisions, the trail of questions and the answers you gave, the hypotheses dropped, and what's still open. So the **context is never lost** between sessions, and a future agent can see not just *what* was decided but *how* you got there.

> **Why it exists:** a grilling produces a lot of valuable reasoning that doesn't all fit in `CONTEXT.md` (vocabulary), an ADR (one hard decision), or a plan (the path forward). The raw trail — the questions, the back-and-forth, the rejected options — used to evaporate when the session ended. This is the durable record of that thinking.

## Difference from sibling artifacts

| | `docs/grills/` | `CONTEXT.md` | `docs/adr/` | `docs/plans/` |
|---|---|---|---|---|
| What it is | trail of a grilling on a topic | canonical vocabulary | one hard-to-reverse decision + why | execution plan for a feature |
| Granularity | one file per **topic**, many dated sessions inside | one glossary | one decision per file | one plan per feature |
| Contains | Q&A, closed decisions, dropped hypotheses, open questions | terms only | the decision and its trade-off | numbered changes to make |
| When | during/after every grill | when a term is pinned | when a decision is hard + surprising + a trade-off | when the grill closes into work |

The grill doc is **upstream** of the others: what crystallises during the session flows out to `CONTEXT.md` (a term), `docs/adr/` (a hard decision), or `docs/plans/` (the plan) — and the grill doc keeps a pointer to where it went. It's the source memory, not a replacement.

## One file per topic (find-then-edit-or-create)

A grill doc is keyed by **topic**, not by date. At the start of a grilling, `/grill-with-docs` looks in `docs/grills/` for an existing file on the same topic:

- **Found** → it **edits** that file, appending a new dated session entry (so re-grilling the same topic accumulates history in one place).
- **Not found** → it **creates** a new file for the topic.

Each session inside the file is stamped with its **date/time**, so the chronology is preserved within the topic.

## Naming convention

`<topic-slug>.md` — the slug of the subject, e.g. `checkout-flow.md`, `installment-discount.md`. The filename does **not** carry a date (the dates live inside, one per session entry). Pick a stable, topic-level slug so the next grill on the same subject lands on the same file.

## How it's maintained (the `grill-with-docs` skill)

Don't write these by hand. Run **`/grill-with-docs`** — it opens (or creates) the topic's file and captures decisions and the Q&A trail **inline as the session unfolds**, not batched at the end. Use [`_template.md`](_template.md) for the per-session structure.

## Grilling sessions

- _(none yet — created/updated by `/grill-with-docs`)_
