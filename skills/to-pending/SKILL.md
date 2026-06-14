---
name: to-pending
description: Record a PENDING ITEM (a loose end to revisit — deferred edge case, postponed decision, TODO, tech debt, open question) as a detailed doc under docs/pendencias/, following best practices (self-sufficient, with why + impact + next step). Also resolves/archives completed pending items. Use when something is left pending mid-work ("we'll look at it later", "left pending", "don't forget to", "note this pending item"), or to mark a pending item as resolved.
argument-hint: "<what was left pending>  |  done <file-or-slug>"
---

This skill has **two modes**. Decide by the argument:

- Argument starts with `done` (or `resolved`/`finish`) → **RESOLVE mode**.
- Anything else (including no argument) → **RECORD mode**.

First, find today's date (`date +%F`) and confirm the `docs/pendencias/` folder (if it doesn't exist, suggest running `/setup-pedro-mota`, which creates the whole structure).

---

## RECORD mode — detail the pending item

The goal is to capture a loose end **before it's forgotten**, detailed enough that "future-you" (or another agent) can pick it up **without this conversation's context**. A one-word TODO isn't enough.

### 1. Identify the pending item

Use the argument (if any) and what was said in this conversation. If several things were left pending, **one per file** — record each. If it's vague, ask 1-2 short questions to nail the scope (never invent impact or reason).

### 2. Name and location

`docs/pendencias/YYYY-MM-DD-short-title.md` (today's date + slug of the title). Follow the repo's `docs/pendencias/README.md` if it differs.

### 3. Detail it following best practices

Use the repo's template (`docs/pendencias/_template.md`) or these sections. **Each pending item must be self-sufficient and actionable**:

1. **What's pending** — exactly what's left to do/decide. Concrete, not vague ("handle the X error when Y" > "improve errors").
2. **Why it was deferred** — the reason for postponing (out of scope, dependency, missing decision, time).
3. **Impact / risk if left untouched** — what hurts if no one picks it up (latent bug, growing debt, affected user) + urgency.
4. **Suggested next step** — how to pick it up: which file to open, which question to answer, who decides.
5. **Related** — real links: `docs/system/feature-*.md`, plan, ADR, issue, commit, code (`path:line`).

At the top: `## Date: YYYY-MM-DD · Area: <feature> · Priority: <high|medium|low>`.

Principles (backlog/issue best practices): specific and context-free · capture the *why and the impact*, not just the "what" · actionable · linked · dated and prioritized · one item per file. **Don't duplicate** what's already in plans/ADRs/feature-docs — reference it.

### 4. Update the index

Add the pending item to the `docs/pendencias/README.md` list (link + 1 sentence + priority).

### 5. Close out

State the created path. If the pending item is big enough to become a **plan** (`/to-plan`) or is already ready to be **prioritized work** (an issue in the tracker), point that out as the graduation path — but the lightweight record here already ensures it's not lost.

---

## RESOLVE mode — mark a pending item as resolved

Argument: `done <file-or-slug>`.

### 1. Locate

Search `docs/pendencias/` (outside `done/`) for the matching file. Ambiguous → list and ask. No argument → list the open pending items and ask which one.

### 2. Record how it was resolved

At the top of the file, add: `> ✅ **Resolved on YYYY-MM-DD** — <how> (implemented / became [plan X] / became issue #N / no longer applies).` Be honest: if "resolved" because it stopped making sense, say so.

### 3. Move to `done/`

- Create `docs/pendencias/done/` if needed.
- `git mv docs/pendencias/<file> docs/pendencias/done/<file>` (preserves history). Outside git, `mv`.

### 4. Update the index

Remove the pending item from the open list in `docs/pendencias/README.md` (move it to a "Resolved" section or remove it, per the README).

### 5. Chain

If the resolution was to **do** something, remember to `/sync-doc` the feature. If it **became a plan**, create it with `/to-plan`. If there was a lesson, record it in `docs/aprendizados/`.

---

## Notes

- This skill **implements nothing** — it only records (RECORD) or archives (RESOLVE) the pending item.
- `git add` **explicitly** the files you created/moved (never `git add -A` — there may be other sessions in the same checkout). Don't commit unless asked.

## Related skills (the ecosystem)

`/to-pending` is the lightweight "don't forget" layer. Neighbors:

- **`/setup-pedro-mota`** — creates `docs/pendencias/` and the whole structure. Run it first if the folder doesn't exist.
- **`/to-plan`** — when a pending item grows and becomes a feature to plan, promote it to a plan in `docs/plans/`.
- **`/sync-doc`** — when the pending item is resolved by writing code, sync the living doc.
- **Issue tracker / `/triage`** — when the pending item is prioritized to be worked on, graduate it to a formal issue.
- **`docs/aprendizados/`** — if the pending item existed because of a mistake, record the lesson there.

Quick distinction: **pending** = loose end to revisit (light); **plan** = feature to execute (complete); **issue** = prioritized/triaged work; **lesson** = mistake not to repeat.
