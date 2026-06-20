---
name: night-shift
description: Autonomously drain the Click Notes board — run [READY FOR DEV] tasks back-to-back, unattended (e.g. overnight), implementing each from its linked plan, committing green work to main, trying hard to resolve failures before parking, and leaving a morning report. Built for "plan by day, code by night". Use to "let the AI code overnight", "drain the task board autonomously", "run the board".
argument-hint: "(empty = drain all ready) | <max N tasks> | <group/tag scope>"
---

# Night Shift

The **unattended, multi-task** drain on top of `/do-task`: it runs many `[READY FOR DEV]` tasks back-to-back with the guard rails an overnight run needs, so you can plan all afternoon and let the agent build all night. `/do-task` does one task with you watching; `/night-shift` does the whole board with nobody watching.

Because it runs unattended and **commits to main**, it is deliberately conservative: it only touches **AFK** tasks that have a **detailed plan + runnable verification**, it **only commits green work**, it **never runs an HITL task**, and it **does not push** (pushing can auto-deploy — you review and push in the morning).

Prerequisite: the **Click Notes MCP** is connected and the board was populated by `/to-tasks` — each task must carry a detailed plan pointer, a runnable **Verify** block, and the context anchor. If tasks lack those, `/night-shift` can't self-check unattended; fix the board with `/to-tasks` (or the plan with `/to-plan`) first.

## Pre-flight (once, before any task)

A run that starts on broken ground produces broken commits all night. Gate hard:

1. **Clean baseline.** Working tree clean, or only changes you intend. If there's unexpected uncommitted WIP (a parallel session in a shared checkout), **STOP and report** — don't mix your overnight commits with someone else's work.
2. **Environment ready.** Deps installed, DB migrated, the dev/build toolchain works (run the repo's documented setup if needed).
3. **Green baseline.** Run the repo's full check suite (typecheck + unit + e2e as applicable) on the **untouched** tree. If it's **RED, STOP** — you can't distinguish your breakage from pre-existing failures. Report the failing baseline.
4. **Board ready.** At least one `[READY FOR DEV]` task whose plan is detailed and whose Verify steps are runnable. List what you'll attempt + the run bounds (max N, scope, org).

Then announce the contract and proceed unattended: *"Draining up to N ready tasks · committing each to main on green (no push) · parking anything I can't resolve · report at the end."*

## The drain loop

Repeat until no eligible task remains, a stop condition fires, or the cap is hit:

### 1. Pick the next task
`list_tasks` (OPEN) → first `[READY FOR DEV]` whose **Blocked by** is satisfied. Skip `[PLANNING]`, `[WIP]`, `[BLOCKED]`. **Skip HITL tasks — leave them for the human** (note them for the report). Order by priority, then age. Resolve `organizationId` if there are several orgs.

### 2. Ground in the project's docs, then implement
Run the single-task discipline (see `/do-task` for the full steps): read the task → **verify the plan is detailed** (if not, park it — never code blind) → **fully ground in the project's docs** → claim `[WIP]` → implement, respecting the plan's invariants and ADRs.

**The grounding step is non-negotiable.** An unattended agent has no human to catch drift, so each task must be built from the project's own knowledge base, never guessed. For *every* task, before writing a line:
- **Understand the project first** — what it is, how the pieces fit. Start at `docs/system/README.md` (the "Topic map").
- **Read every `docs/system/feature-*.md` that this task touches** — that's the source of truth for what the code does TODAY and exactly where to touch it. A task implemented without its system docs is how the run drifts.
- The **ADRs** the plan cites — the *why* you must not violate.
- `CONTEXT.md` — the canonical vocabulary, so names match the codebase.
- `docs/learnings/` + `docs/pending/` for the area — known traps and open loose ends.
- Enough of the surrounding code to see how this slice fits the whole, not just the lines you change.

Only then implement. `/night-shift` is this procedure, looped and unattended — the discipline that keeps each task *perfect and on-context* is reading the docs, every time.

### 3. Self-verify — green or nothing
Run the task's **Verify** commands + the repo's checks. "Done" is green output, not a hunch. If the Verify block is missing or unrunnable, treat the task as not-ready: park it (you can't self-check unattended) and move on.

### 4. Try hard to resolve a failure (don't give up on the first red)
If verification fails, enter a **bounded diagnosis loop** (à la `/diagnose`): reproduce → form one hypothesis → minimal fix → re-verify. Several honest rounds before giving up. Stay **inside the plan's closed decisions** — never invent scope or reopen a decision just to make a test pass. Resolving is the job; parking is the fallback.

### 5a. On green → commit + close
- **Commit atomically to main**, locally — **do not push** (push may auto-deploy; that's the morning's review). Stage **only the files this task touched**, by explicit path (there may be parallel sessions — never `git add -A`). One commit, message referencing the task title + plan slug.
- Mark the task **COMPLETED**, strip `[WIP]`.
- **Implementation-trail comment** (`add_task_comment`): what changed, files/symbols touched, decisions made during implementation, the commit ref, and anything the next slice must know. *This is how context carries from one task to the next* — the board accumulates an implementation trail, not just statuses.
- Promote any sibling that was `[PLANNING]` only because it was blocked by this one → `[READY FOR DEV]`.

### 5b. On genuine stuck (after real effort) → park, don't loop
- **Revert this task's uncommitted changes** (`git restore`/`checkout` the touched files) so the tree stays clean for the next task and main stays green.
- Mark `[BLOCKED]`, comment the **root cause**, what you tried, and the specific decision/help it needs.
- Continue to the next task. Don't re-grab a `[BLOCKED]` task this run.

### 6. Stop conditions (protect the repo overnight)
Stop the whole run and jump to the report if:
- the baseline check suite goes **RED and you can't restore it** within the resolve loop (don't pile commits on a broken main);
- **~3 consecutive tasks fail** to complete (something systemic — env broke, a shared dependency regressed);
- the task **cap** is reached, or no eligible task remains.

## Morning report

Post a summary as a comment on the plan's **root task**, and surface it to the user:

- **✅ Completed** — task → commit ref → one line of what shipped.
- **⛔ Blocked** — task → root cause → what you tried → what it needs from you.
- **🙋 HITL left for you** — tasks skipped because they need a human (the decision/review each needs).
- **🧹 Deferred** — anything recorded via `/to-pending`; lessons added to `docs/learnings/` if a trap bit you.
- **Repo state** — final test/build status, **N commits on local main (unpushed)**, anything left dirty.
- **▶️ Next** — the single most useful thing for you to do first when you wake up.

## Guard rails (always)

- **Commit only on green, only the task's own files, explicitly staged. Never push.** A red task never reaches main.
- **Never** run an HITL task autonomously; **never** reopen the plan's closed decisions to force a pass.
- **Resumable/idempotent:** a stale `[WIP]` from a crashed prior run can be reclaimed — re-verify its real state (committed? reverted?) before re-attempting.
- **One task = one commit.** Keep the morning diff reviewable.
- **Ground before coding, every task.** No task is implemented without reading the project's `docs/system/` feature docs + the cited ADRs + `CONTEXT.md` for its area. Unattended drift comes from skipping this.
- If the board keeps making you park tasks, the plan/board is under-specified — say so; the fix is sharper `/to-tasks` / `/to-plan`, not guessing.

## Related skills

- **`/to-tasks`** — populates the board this skill drains. Its **Verify** block, **context anchor**, **Do NOT** list and self-contained slices are exactly what make an unattended run reliable.
- **`/do-task`** — the single-task executor this loop runs per task; use it directly for a supervised, one-at-a-time run.
- **`/diagnose`** — the disciplined loop `/night-shift` uses when a task fails verification.
- **`/clicknotes-tasks`** — reconcile/clean the board the morning after.

Daytime: **grill → `/to-plan` → `/to-tasks`.**  Overnight: **`/night-shift`.**  Morning: read the report → push what's good → `/sync-doc` + `/to-plan done`.
