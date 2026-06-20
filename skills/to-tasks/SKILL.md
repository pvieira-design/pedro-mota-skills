---
name: to-tasks
description: Turn an implementation plan (docs/plans/) into Click Notes tasks + subtasks that an autonomous agent can pick up and build. The plan becomes one root task; each vertical slice becomes a subtask, gated in the title with [PLANNING] / [READY FOR DEV]. Use after /to-plan to publish a plan as executable tasks ("create the tasks", "break the plan into tasks", "publish to Click Notes").
argument-hint: "<plan file-or-slug>"
---

# To Tasks

Turn a finished plan into **Click Notes tasks + subtasks** that a later, autonomous agent (`/do-task`) can grab and implement without reopening any decision.

This is the Click Notes counterpart of `/to-issues`: same vertical-slice philosophy, but the destination is the **Click Notes MCP** (tasks/subtasks/groups) and each grab-able unit is **gated in its title** so an agent scanning the list knows at a glance what's safe to code.

Prerequisites: the **Click Notes MCP** is connected, and a plan already exists in `docs/plans/` (written by `/to-plan`). If there's no plan yet, stop and run `/to-plan` first — this skill consumes a plan, it doesn't invent one.

## The title gate (the whole point)

`list_tasks` shows titles. So readiness lives **in the title**, as a tag prefix, and the Click Notes status carries the lifecycle:

| Title tag | Click Notes status | Meaning for an agent |
|---|---|---|
| `[PLANNING]` | OPEN | Still being shaped. **Do NOT code.** `/do-task` waits, or continues planning only if asked. |
| `[READY FOR DEV]` | OPEN | Decided and grab-able. An autonomous agent may pick it up. |
| `[WIP]` | IN_PROGRESS | Claimed by an agent. Others skip it (prevents two agents on the same slice). |
| _(no tag)_ | COMPLETED | Done. The tag is removed when the task completes. |

There is no `[DONE]` tag — "done" is the COMPLETED status. There is no `[BLOCKED]` tag — a slice that depends on an unfinished slice simply stays `[PLANNING]` (with a **Blocked by** line in its description) and is promoted to `[READY FOR DEV]` once its blocker completes.

## The structure (plan → task tree)

- **The plan = one root task.** Title `[READY FOR DEV] <plan title>` (or `[PLANNING]` if the whole plan is still being shaped). Its description is the **spec anchor**: the pointers an executing agent needs (plan path, ADRs, feature docs). Optionally placed in a Click Notes **task group** (a project) if one fits — list with `list_task_groups`, create with `create_task_group`.
- **Each vertical slice = one subtask** of that root (created with `create_task` + `parentId`). The subtask is the grab-able unit, so the **gate tag goes on the subtask**.

> Click Notes note: subtasks are **not** placed in a group and are **not** mirrored to ClickUp — only the root task (the plan) is. That's expected with this structure: ClickUp sees the plan as one task; the slices live as subtasks inside it.

## Process

### 1. Locate and read the plan

Find the plan in `docs/plans/` matching the argument (by slug/date). If ambiguous, list candidates and ask; if no argument, list the open plans (root of `docs/plans/`, outside `done/`) and ask which one.

Read it in full **plus** the artifacts it cites — the ADRs in `docs/adr/`, the `docs/system/feature-*.md`, and `CONTEXT.md` — so task titles and descriptions use the project's real vocabulary and respect its decisions. Don't re-derive the plan; just absorb it.

### 2. Draft the slices

Break the plan into **tracer-bullet vertical slices**. Each slice cuts through ALL layers end-to-end — not a horizontal slice of one layer:

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests).
- A completed slice is demoable or verifiable on its own.
- Prefer many thin slices over a few thick ones.
</vertical-slice-rules>

If the plan already enumerates slices/phases, reuse them. For each slice decide:
- **Title** — short, in the project's vocabulary.
- **Blocked by** — which other slices must complete first (if any).
- **Ready or planning** — `[READY FOR DEV]` if it has no unmet blocker and the design is settled; `[PLANNING]` otherwise.
- **Mode — AFK or HITL** — *AFK* (away-from-keyboard): an agent can implement and finish it alone. *HITL* (human-in-the-loop): it needs a human at some point — an architectural decision, a design review, a risky/destructive op. **Prefer AFK**; when a slice must be HITL, say exactly what needs the human. (`/do-task` carries an AFK slice to done, but stops an HITL slice at the human checkpoint.)

### 3. Quiz the user

Present the breakdown as a numbered list — for each slice: **title · ready/planning · mode (AFK/HITL) · blocked-by · what it covers** (the user stories / acceptance it addresses, if the plan has them). Ask:
- Does the granularity feel right (too coarse / too fine)?
- Are the dependencies correct?
- Should any slice be merged or split?
- Are the right slices `[READY FOR DEV]` vs `[PLANNING]`?
- Are the right slices marked AFK vs HITL?

Iterate until the user approves. (Skip the quiz only if the user explicitly said "just publish it".)

### 4. Create the root task

`create_task` with:
- **title**: `[READY FOR DEV] <plan title>` (or `[PLANNING]` if nothing is ready yet).
- **description**: the root template below.
- **groupId**: an existing group if one fits (else omit). If the user wants a new project group, `create_task_group` first.
- **priority** / **dueDate**: only if the plan implies them.

If multiple organizations exist, resolve the target with `list_organizations` and pass `organizationId` (omit when there's only one).

### 5. Create the subtasks (one per slice), in dependency order

Publish blockers first so you can name real blocker titles. For each slice, `create_task` with `parentId` = the root task id and:
- **title**: `[READY FOR DEV] <slice title>` — or `[PLANNING] <slice title>` if it's blocked by a not-yet-done slice.
- **description**: the subtask template below.

### 6. Report

Tell the user: the root task id + the subtask ids, how many are `[READY FOR DEV]` vs `[PLANNING]`, and that an agent can now run `/do-task` (empty arg) to grab the next ready slice. If any slice is `[PLANNING]` only because of a blocker, say which blocker unlocks it.

---

## Description templates

Keep descriptions **pointer-first** — reference the repo's docs by path, don't copy them. Point at the **knowledge base** (the plan, ADRs, `feature-*.md`) — those paths are stable and are the source of truth. But describe *behavior*, not implementation: **avoid pinning specific source files / line numbers** in "What to build" (they go stale fast). Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can — a state machine, reducer, schema, or type shape — inline just that decision-rich bit and note it came from a prototype.

<root-task-template>
**Plan:** `docs/plans/<slug>.md` — read it first; do not reopen its closed decisions.

**Goal:** <2-3 lines: the problem this plan solves>.

**Source (if any):** <the originating GitHub issue / Click Notes task / PRD> — for context; this skill references it, never modifies it.

**Read before coding (knowledge base):**
- ADRs: `docs/adr/NNNN-...md` (the *why* behind <decision>)
- Feature docs: `docs/system/feature-<name>.md` (what the code does today)
- Vocabulary: `CONTEXT.md` (<key terms>)
- Learnings/pending: `docs/learnings/...`, `docs/pending/...` (if relevant to this area)

**Slices:** see the subtasks. Grab a `[READY FOR DEV]` one via `/do-task`.

**Done when:** every subtask is COMPLETED. Then run `/sync-doc <feature>` and `/to-plan done <slug>`.
</root-task-template>

<subtask-template>
**What to build:** <the end-to-end behavior of this slice — not layer-by-layer>.

**Mode:** AFK — or "HITL: <what needs a human: a decision / review / risky op>".

**From plan:** `docs/plans/<slug>.md` → <section/anchor>. Cited decisions: <ADR links if any>.

**Acceptance criteria:**
- [ ] <criterion 1>
- [ ] <criterion 2>

**Blocked by:** <blocker slice title> — or "None, can start immediately".

**Must not break:** <invariant(s) from the plan / ADRs>.
</subtask-template>

---

## Notes

- This skill **does not implement** anything — it only publishes the task tree. Implementation is `/do-task`.
- Don't duplicate the plan/ADRs/feature docs into task descriptions — **reference them by path**. A task is a ticket; the repo doc is the spec.
- Use real names from the project's vocabulary (`CONTEXT.md`), not placeholders.
- If the plan came from an existing issue/task (a GitHub issue, a Click Notes task, a PRD), **reference** it in the root task but **don't close or modify** the source.
- Soft-delete (`delete_task`) and restore (`restore_task`) exist if you publish wrong and need to redo — confirm with the user before deleting.

## Related skills (the ecosystem)

`/to-tasks` sits between planning and autonomous execution:

- **`/to-plan`** — writes the plan in `docs/plans/` that this skill consumes. Run it first.
- **`/do-task`** — the counterpart: an agent grabs a `[READY FOR DEV]` task this skill created, reads the linked plan + ADRs + feature docs, and implements it. When all subtasks complete, it suggests `/sync-doc` + `/to-plan done`.
- **`/to-issues`** — the same vertical-slice idea but published to the GitHub/markdown issue tracker instead of Click Notes. Use `/to-issues` for the public issue tracker, `/to-tasks` for the Click Notes work board.
- **`/handoff`** — the other way to pass a plan to a fresh agent (a ready-to-paste prompt). `/to-tasks` + `/do-task` is the **board-driven** alternative: publish once, let agents pull.

Typical loop: **grill → `/to-plan` → `/to-tasks` → `/do-task` (autonomous) → `/sync-doc` → `/to-plan done`.**
