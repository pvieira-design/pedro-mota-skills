# Attribution & provenance

This repo bundles two families of agent skills, all under the MIT License (see [LICENSE](LICENSE)).

## Original skills by Matt Pocock — MIT

Included as-is (or near-as-is) from **[github.com/mattpocock/skills](https://github.com/mattpocock/skills)** (MIT, © 2026 Matt Pocock). Full credit to Matt Pocock:

- `grill-with-docs`, `grill-me` — grilling / design stress-testing
- `to-issues`, `to-prd` — turn context into issues / a PRD
- `triage` — issue triage state machine
- `tdd` — test-driven development (red-green-refactor)
- `improve-codebase-architecture` — find deepening/refactor opportunities
- `ubiquitous-language` — extract a DDD glossary
- `zoom-out` — higher-level perspective on code
- `diagnose` — disciplined debugging loop
- `prototype` — throwaway prototype to flesh out a design
- `setup-matt-pocock-skills` — per-repo agent config (issue tracker / triage / domain)

## Added & adapted skills by Pedro Mota — MIT

Authored or substantially adapted by Pedro Mota, building on the same philosophy:

- `setup-pedro-mota` — **new**. Complete knowledge-base bootstrap (CONTEXT.md, docs/adr, docs/system, docs/plans, docs/pending, docs/learnings) + CLAUDE.md; calls `setup-matt-pocock-skills`.
- `to-plan` — **new**. Turn grilling decisions into an implementation plan under `docs/plans/`; close it to `done/`. Works together with `docs/adr/`.
- `to-pending` — **new**. Record/resolve loose ends under `docs/pending/`.
- `sync-doc` — **new**. Keep `docs/system/` (living technical docs) in sync with the code.
- `handoff` — **adapted** from Matt Pocock's handoff. Rewritten to emit a ready-to-paste prompt (continue-planning vs execute) wired to the knowledge base, saved under `.handoff/` and opened.
- `to-tasks` — **new**. Publish a plan from `docs/plans/` as Click Notes tasks + subtasks (gated `[READY FOR DEV]` / `[PLANNING]` / `[WIP]` in the title) for an autonomous agent to pull.
- `do-task` — **new**. An agent grabs a `[READY FOR DEV]` Click Notes task and implements it from the linked plan + ADRs + feature docs, obeying the title gate.
- `clicknotes-meeting`, `clicknotes-memory`, `clicknotes-recall`, `clicknotes-tasks` — **new** (in `skills/clicknotes/`). Drive the Click Notes MCP: optimize a meeting's notes + tasks, create/update knowledge-graph memories per the org conventions, recall memories for the current topic, and reconcile the task board.

If you redistribute, keep this notice and the LICENSE.
