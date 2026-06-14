# Pending items (`docs/pending/`)

**Loose ends** — everything left **pending to look at later** that must not be forgotten: a deferred edge case, a postponed decision, a TODO/tech debt, an open question. Each file is **one** pending item, detailed enough that "future-you" (or another agent) can pick it up without the original context.

> **Why it exists:** in the middle of work we always defer things ("we'll look at this later"). If that lives only in someone's head or a lost comment, it vanishes. This is the **in-repo backlog of loose ends** — cheap to record, easy to revisit. Record with `/to-pending`.

## When to record a pending item

When you **consciously defer** something during work: left a case out of scope, didn't resolve a doubt, spotted tech debt, decided "later". If it's already prioritized work ready to pick up, make it an **issue** (tracker); if it's a whole feature to plan, make it a **plan** (`/to-plan`). The pending item is the lightweight "don't forget" layer.

## Difference from sibling folders/tools

| | `docs/pending/` | `docs/plans/` | Issue tracker | `docs/learnings/` |
|---|---|---|---|---|
| What it is | loose end / look-at-later | execution plan for a feature | tracked/triaged formal work | lesson from a mistake |
| Size | small, 1 item | full doc | triaged issue | 1 lesson |
| When | deferred something mid-way | about to implement something decided | will be prioritized/worked | already got bitten |

A pending item can **graduate**: become a `/to-plan` (if it grew), become an issue (if prioritized), or be resolved directly.

## How to detail it well (best practices)

Each pending item must be **self-sufficient and actionable**. Use [`_template.md`](_template.md). Principles:

1. **Specific and context-free** — whoever reads it in 3 months understands it alone.
2. **Capture the why and the impact**, not just the "what" — why it was deferred and what happens if no one touches it.
3. **Actionable** — a concrete next step to pick it up.
4. **Linked** — point to the relevant code/feature/plan/ADR/issue.
5. **Dated and prioritized** — so it can be triaged later.
6. **One item per file.**

## Naming convention

`YYYY-MM-DD-short-title.md`. Resolved → move to `done/` with a one-liner on how it was resolved (or promote to an issue/plan and record where it went).

## Pending

- _(none yet — record with `/to-pending`)_
