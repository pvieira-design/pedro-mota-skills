# System technical docs (`docs/system/`)

How the **code and skeleton** of this project are built — the **current** state of what exists. One feature/component per file (`feature-<name>.md` / `<component>.md`).

> **This folder is the source of truth for the code.** Before touching any part of the system, start here — don't go scanning the code in the dark. Reading 1-2 feature-docs (a few KB) is far cheaper and more accurate than tracing where something lives. If the doc diverges from the code, the doc is wrong: fix it.

> **Maintenance rule:** when you create or change a feature, create/update the matching doc here using [`_template.md`](_template.md) and run **`/sync-doc`** at the end. Every new doc goes into the index below.

## 🧭 Where to start (read BEFORE touching the code)

1. Find the topic in the **[Topic map](#topic-map)** → it points to the area's `feature-*.md` (+ ADR, if any).
2. Read the **`feature-*.md`**. Every feature-doc follows the same format: **What it is · Where it lives (real paths) · API/procedures (with permission gate) · Business rules (non-obvious) · External dependencies · Key files**. You come out knowing where to touch and what not to break.
3. If the project has `CONTEXT.md` / `docs/adr/`, read them for the domain vocabulary and the "why" behind decisions.
4. Only then open the code — now knowing the right file.

## Topic map

| Looking for…       | Doc(s)                      | ADR  |
| ------------------ | --------------------------- | ---- |
| <topic/feature>    | [feature-x](feature-x.md)   | —    |

## Documents

| Doc                          | Covers                                  |
| ---------------------------- | --------------------------------------- |
| [_template.md](_template.md) | Skeleton to copy for each new doc       |

## Sibling folders

- [`../plans/`](../plans/README.md) — **work plans** (what we're going to do; future). Create with `/to-plan`.
- [`../pendencias/`](../pendencias/README.md) — **loose ends** to revisit (don't forget). Record with `/to-pending`.
- [`../aprendizados/`](../aprendizados/README.md) — **lessons** from mistakes already made (don't repeat).
