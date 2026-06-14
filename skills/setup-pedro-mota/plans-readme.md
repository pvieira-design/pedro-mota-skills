# Implementation plans (`docs/plans/`)

**Work plans** — execution documents for a feature/change that is **still going to be implemented** (by another agent or in a future session). Ephemeral by nature: they're born before the code and get archived once the feature ships.

## Difference from `docs/system/`

| | `docs/plans/` | `docs/system/` |
|---|---|---|
| **What it is** | plan of **what we're going to do** (intent) | technical doc of what **already exists** in the code (current state) |
| **Tense** | future ("we'll record…", "create function…") | present ("`service.ts` records…") |
| **Life** | ephemeral — becomes code and is archived in `done/` | living — must never diverge from the code |
| **Owner** | whoever plans / hands off to an agent | whoever maintains the feature (via `/sync-doc`) |

> Rule: when you **finish** implementing a plan from here, update the matching `docs/system/feature-*.md` (run `/sync-doc`) and mark the plan ✅ done by **moving it to `done/`** (see "Lifecycle"). The technical doc is the source of truth for the code; the plan is just the path to get there.

## How to build/close a plan (the `to-plan` skill)

Don't write the plan by hand. At the end of a grilling session (`/grill-me` or `/grill-with-docs`), run **`/to-plan`** — it distills the conversation's decisions into this format and adds it to the index. When the feature ships, run **`/to-plan done <slug>`** to stamp the ✅ badge, move the file to `done/`, and update this index.

## Lifecycle

- **Open** — stays at the root of `docs/plans/`, with the header `> 🚧 **Status: ready to implement**`.
- **Done** — moves to `docs/plans/done/`, with `# ✅ ...` in the title and `> ✅ **Completed on YYYY-MM-DD.**` at the top.

## Naming convention

`YYYY-MM-DD-short-title.md` (plan creation date + slug). E.g. `2026-06-13-installment-no-interest-discount.md`. The name does **not** change when completed — only the folder (root → `done/`).

## Suggested plan structure

1. **Goal / context** — the problem in 2-3 lines.
2. **Closed decisions** — what's already been decided (and why), so the agent doesn't reopen it.
3. **Current model** — how the relevant code works today (real paths).
4. **Changes per file** — numbered, with path + function + snippet.
5. **Rules / invariants** — what must NOT break.
6. **Tests** — cases to cover.
7. **Acceptance criteria** — verifiable checklist.
8. **Out of scope** — what's explicitly left out.

## Plans

- _(none yet — create with `/to-plan`)_
