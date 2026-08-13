# System technical docs (`docs/system/`)

How the **code and skeleton** of this project are built — the **current** state of what exists. One feature/component per file (`feature-<name>.md` / `<component>.md`).

> **This folder is the source of truth for the code.** Before touching any part of the system — or asking the first question in `/grill-with-docs` or `/wayfinder` — start here. Reading the target feature-doc and its complementary neighbours is far cheaper and more accurate than questioning the user about facts or tracing the code in the dark. If the doc diverges from the code, the doc is wrong: fix it.

> **Maintenance rule:** when you create or change a feature, create/update the matching doc here using [`_template.md`](_template.md) and run **`/sync-doc`** at the end. Every new doc goes into the index below.

## 🧭 Where to start (read BEFORE planning questions or code)

1. Find the topic in the **[Topic map](#topic-map)** → it points to the target `feature-*.md` (+ ADR, if any).
2. Read that feature-doc **and the adjacent/complementary feature-docs** whose rules, APIs or state interact with the proposed work.
3. Read the cited ADRs and, when present, `CONTEXT.md` for vocabulary and durable reasons.
4. Summarize existing behavior, seams and genuine unknowns. In a grill or Wayfinder session, ask only decisions the knowledge base and code cannot answer.
5. Only then inspect the specific code paths named by the docs.

## Topic map

| Looking for…       | Doc(s)                      | ADR  |
| ------------------ | --------------------------- | ---- |
| _(none yet)_       | —                           | —    |

## Documents

| Doc                          | Covers                                  |
| ---------------------------- | --------------------------------------- |
| [_template.md](_template.md) | Skeleton to copy for each new doc       |

## Sibling folders

- GitHub Issues labelled `spec` — **approved future work**. Publish with `/to-spec` and decompose with `/to-tickets`.
- GitHub Issues labelled `pending` — **loose ends** to revisit outside the execution frontier. Record with `/to-pending`.
- [`../learnings/`](../learnings/README.md) — **lessons** from mistakes already made (don't repeat).
