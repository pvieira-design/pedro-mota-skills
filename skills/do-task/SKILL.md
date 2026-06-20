---
name: do-task
description: Pick a [READY FOR DEV] task from Click Notes and implement it autonomously — read its linked plan in docs/plans/, the cited ADRs and feature docs, then build, test, and mark it done. Obeys the title gate (never codes a [PLANNING] task; skips [WIP]). Use to start implementing a planned task, "grab the next task", or "implement this task".
argument-hint: "<task id-or-title>  |  (empty = next ready task)"
---

# Do Task

Take one **Click Notes** task that's been marked ready, and implement it end-to-end — correctly, because you read the plan and the decisions behind it first. This is the executing half of the board-driven loop that `/to-tasks` sets up.

Prerequisite: the **Click Notes MCP** is connected. The task you implement should have been published by `/to-tasks` (so it carries a plan pointer in its description and a gate in its title).

## The gate this skill obeys (read first)

The task title carries a tag. **Never ignore it:**

| Title tag | What you do |
|---|---|
| `[READY FOR DEV]` | Grab-able. Claim it and implement (the normal path). |
| `[PLANNING]` | **Do NOT code.** It's still being shaped. By default, report it's not ready and stop. Continue *planning* it (via `/grill-with-docs` → `/to-plan`) **only if the user explicitly asked** to continue the planning. |
| `[WIP]` | Already claimed by another agent — **skip it**, pick a different one. |
| _(no tag, COMPLETED)_ | Already done — skip. |

## Process

### 1. Select the task

- **Argument given** (id or title) → fetch it with `get_task` (resolve a title via `list_tasks` if needed).
- **No argument** → `list_tasks` (status `OPEN`), and pick the first **`[READY FOR DEV]`** task whose **Blocked by** is satisfied (its blocker is COMPLETED). Skip `[PLANNING]` and `[WIP]`. If several qualify, take the highest `priority` (then oldest); if it's genuinely a toss-up and the user is present, list the top few and ask.

If multiple organizations exist, resolve with `list_organizations` and pass `organizationId`.

Honor the gate from the table above before doing anything else.

### 2. Read the task in full

`get_task` to load the full description, comments, parent, and any subtasks. From the description, extract the **plan pointer** (`docs/plans/<slug>.md`) and the **knowledge-base reading list** (ADRs, `feature-*.md`, `CONTEXT.md`, learnings, pending) that `/to-tasks` embedded.

### 3. Verify there is a detailed plan — do NOT code blind

Open `docs/plans/<slug>.md`. This is the guard rail:

- **Plan missing, or too thin to implement safely?** Stop. Leave a comment on the task (`add_task_comment`) explaining what's missing, and report to the user — suggest `/to-plan` (or `/grill-with-docs`) to flesh it out. Do **not** start coding from the task title alone.
- **Plan present?** Read it fully. Treat its "Closed decisions" / invariants as settled — don't reopen them.

### 4. Read the wired knowledge base (the repo ritual)

Follow the project's "before any feature" ritual so you don't err in the implementation:
1. `docs/system/README.md` → the "Topic map" → the relevant `feature-*.md` (what the code does today).
2. The **ADRs** the plan cites (`docs/adr/NNNN-*`) — the *why* you must not violate.
3. `CONTEXT.md` — the canonical vocabulary for names.
4. `docs/learnings/` and `docs/pending/` for the area you're touching — known traps and open loose ends.

Then open the actual code, now knowing the right files.

### 5. Claim the task

So no other agent grabs it:
- `update_task_status` → `IN_PROGRESS`, and `update_task` to swap the title tag `[READY FOR DEV]` → `[WIP]`.
- `add_task_comment` with a one-line "picked up by agent — implementing per `docs/plans/<slug>.md`". (Optionally `assign_task` to the relevant member/contact.)

### 6. Implement

Build the slice end-to-end, respecting the plan's invariants and the ADRs. Use `/tdd` if the work benefits from a red-green-refactor loop. Run the repo's checks — typecheck, unit tests, and the e2e suite if the touched flow is covered (see the repo's CLAUDE.md / `e2e/README.md`). Keep the change surgical; match the surrounding code's conventions.

**If the description marks the slice `HITL`** (human-in-the-loop), do the autonomous part, then **stop at the human checkpoint**: comment exactly what needs the human (the decision, review, or approval) plus the work done so far, and **do not mark it COMPLETED** until the human resolves it — never push past a human gate on your own. An **AFK** slice you carry all the way to done.

### 7. Close out the task

On green:
- `update_task_status` → `COMPLETED` and strip the `[WIP]` tag from the title (`update_task`).
- `add_task_comment` summarizing what was built and how it was verified (and the commit ref, if you committed).
- **If this was the last open subtask of its parent**, mark the **parent** COMPLETED too, then tell the user to run `/sync-doc <feature>` (update `docs/system/`) and `/to-plan done <slug>` (archive the plan).
- Promote any sibling slice that was `[PLANNING]` **only** because it was blocked by this one → flip it to `[READY FOR DEV]` so the next `/do-task` can grab it.

Do **not** `git commit`/`push` unless the user asked. Register anything you deferred with `/to-pending`, and record a lesson in `docs/learnings/` if a non-obvious trap bit you.

### 8. If you get blocked or it's ambiguous

Don't guess on a hard call. Leave a comment on the task describing the blocker, revert the title to `[READY FOR DEV]` (and status back to `OPEN`) so it isn't stuck as `[WIP]`, and report to the user with the specific question.

## Notes

- "Autonomous" means you carry the task from ready → done without hand-holding — but the **plan is your contract**. No detailed plan ⇒ no code (step 3).
- One `/do-task` run = one slice. To drain a board, run it repeatedly (each call grabs the next `[READY FOR DEV]`).
- The title gate is advisory metadata for humans+agents; the Click Notes **status** is the source of truth for lifecycle. Keep them consistent (READY↔OPEN, WIP↔IN_PROGRESS, none↔COMPLETED).

## Related skills (the ecosystem)

- **`/to-tasks`** — creates the tasks this skill consumes (plan → root task + slice subtasks, gated in the title). `/do-task` is its executing counterpart.
- **`/to-plan`** — writes the plan in `docs/plans/` that this skill reads as its contract. `/to-plan done <slug>` archives it once every slice is COMPLETED.
- **`/sync-doc`** — run after finishing the slices so `docs/system/` reflects what shipped.
- **`/grill-with-docs`** — what you run instead of coding when the task is `[PLANNING]` and the user asked to continue planning.
- **`/to-pending`** / **`docs/learnings/`** — capture deferrals and traps discovered while implementing.

Typical loop: **grill → `/to-plan` → `/to-tasks` → `/do-task` (autonomous) → `/sync-doc` → `/to-plan done`.**
