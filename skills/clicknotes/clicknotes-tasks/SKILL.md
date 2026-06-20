---
name: clicknotes-tasks
description: Review the open Click Notes tasks, reconcile them against what's actually been done, and update each — mark fully-done ones COMPLETED, move partially-done ones to IN_PROGRESS with a note on what remains. Evidence-based; never marks done without proof. Use when asked to "review the tasks", "update task statuses", "atualizar as tasks", or "reconcile the board".
argument-hint: "<group, tag, or scope>  |  (empty = all open tasks)"
---

# Click Notes — Review & Update Tasks

Sweep the open tasks and bring their status in line with reality: what's finished gets closed, what's half-done gets an honest update on the remaining work. This is the board-reconciliation counterpart to `/do-task` (which closes the one task it implements).

Prerequisite: the **Click Notes MCP** is connected. Resolve `organizationId` with `list_organizations` if the user spans several orgs.

## Process

### 1. Pull the open work

`list_tasks` for status `OPEN` and `IN_PROGRESS` (scope by the argument — a group, a tag's tasks via `get_tag_context`, or all). For anything with subtasks, `get_task` to load the full picture (description, comments, subtasks, acceptance).

### 2. Establish what's actually done — with evidence

Don't guess. Gather proof from whatever's available:
- the **conversation** (the user is telling you what shipped),
- the **repo** — `git log`/diff, `docs/plans/done/`, the code itself,
- task **comments** and the linked plan/spec.

Match each task to evidence. No evidence ⇒ no status change.

### 3. Update each task to match reality

- **Fully done** → `update_task_status` → `COMPLETED`, and `add_task_comment` with what was done + the evidence (commit ref, plan slug, "confirmed in chat <date>").
- **Partially done** → set/keep `IN_PROGRESS`, and `add_task_comment` spelling out **what's done** and **what remains**. Update the `description`/`dueDate` if the scope shifted. If it carries a dev gate in its title (`[WIP]`), keep it consistent with the status.
- **Subtask done, siblings not** → mark that subtask `COMPLETED`; leave the parent `IN_PROGRESS`.
- **All subtasks COMPLETED** → roll the parent up to `COMPLETED`.
- **Not started / blocked** → leave `OPEN`; comment the blocker if known.

### 4. Report

A compact table: **task — old status → new status — note/evidence**, plus a count of completed / advanced / untouched. Call out anything you couldn't verify and left alone, and anything that looks abandoned (old, no movement) for the user to decide on.

## Notes

- **Evidence-based only.** Closing a task you can't prove is done is worse than leaving it open.
- Comments are the audit trail — every status change gets a one-line why.
- This skill reconciles **any** tasks. For the dev loop specifically, `/do-task` already closes the task it builds and promotes the slices it unblocks; run this for the broader sweep (meeting tasks, stragglers, partials).

## Related skills

- **`/do-task`** — implements and closes a single `[READY FOR DEV]` task; this skill is the wider board reconciliation.
- **`/clicknotes-meeting`** — creates the action-item tasks that this skill later reconciles.
- **`/to-tasks`** — publishes a plan as the gated dev tasks that flow through `/do-task` and show up here.
