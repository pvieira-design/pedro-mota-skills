# Pedro Mota Skills

A curated bundle of **project & planning agent skills** for Claude Code (and compatible agents) — mixing [Matt Pocock's skills](https://github.com/mattpocock/skills) with Pedro Mota's optimized ones, focused on one thing: **making the agent smart about a codebase from day one** through a living knowledge base and a tight plan → build → document loop.

👉 **Full visual tutorial:** open [`index.html`](index.html) in a browser.

## The idea

The agent shouldn't re-learn the project every session. These skills install and maintain a `docs/` **knowledge base** so it understands a feature by reading a page, doesn't reopen settled decisions, and doesn't repeat past mistakes.

| Artifact | Question it answers |
|---|---|
| `CONTEXT.md` | what the words mean (glossary) |
| `docs/adr/` | why we decided this way (decisions) |
| `docs/system/` | what the code does today (living docs) |
| `docs/plans/` | what we're going to do (plans) |
| `docs/pending/` | what's left open (loose ends) |
| `docs/learnings/` | where we already erred (lessons) |
| `docs/grills/` | how we reasoned to the decision (grilling memory) |

## The loop

```
1. /grill-with-docs   decide; record the session in docs/grills/, pin vocabulary in CONTEXT.md + write ADRs
2. /to-plan           write the plan in docs/plans/
3. /handoff           hand the plan to a NEW agent — to execute it, or to continue planning
4. implement          the new agent builds it (optionally with /tdd)
5. /sync-doc          update docs/system/ to match the shipped code
6. /to-plan done      archive the plan to docs/plans/done/

along the way:  /to-pending  (defer a loose end)   ·   docs/learnings/  (record a lesson)
```

`/handoff` is the bridge between planning and building: once the plan is written, it produces a ready-to-paste prompt (saved under `.handoff/` and opened) that a **new agent/chat** uses to pick up — either to **execute the plan** or to **continue the planning** — wired to all the docs above.

**Board-driven alternative.** Instead of (or alongside) `/handoff`, run `/to-tasks` to publish the plan as **Click Notes** tasks + subtasks — each grab-able slice gated in its title (`[READY FOR DEV]` to code, `[PLANNING]` to leave alone, `[WIP]` while an agent works it). An agent then runs `/do-task` to pull the next ready task, read its linked plan + ADRs, implement, test, and mark it done. To run the whole board **unattended** — plan by day, code by night — `/night-shift` loops that drain overnight, delivering each green task the way you pick at start (commit + push to main per task, or one PR per task), and leaves a morning report. Publish once, let agents pull.

## Skills

**Setup**
- `setup-pedro-mota` — one-shot knowledge-base bootstrap (+ calls `setup-matt-pocock-skills`).
- `setup-matt-pocock-skills` — per-repo agent config (issue tracker, triage labels, domain layout).

**Grilling & planning**
- `grill-with-docs`, `grill-me` — stress-test a plan against the domain; record each session in `docs/grills/`.
- `to-plan` — distill grilling decisions into a plan; close it to `done/`.
- `to-pending` — record/resolve loose ends.
- `ubiquitous-language` — extract a domain glossary.

**Docs & handoff**
- `sync-doc` — keep `docs/system/` in sync with the code.
- `handoff` — emit a ready-to-paste prompt (continue planning or execute) wired to the docs.

**Tasks & autonomous execution (Click Notes)**
- `to-tasks` — publish a plan as Click Notes tasks/subtasks, gated `[READY FOR DEV]` / `[PLANNING]` in the title (with a runnable Verify block + context anchor per slice).
- `do-task` — an agent grabs a `[READY FOR DEV]` task and implements it from the linked plan + ADRs + feature docs (supervised, one at a time).
- `night-shift` — drains the whole board **unattended** (overnight): runs `do-task` in a loop, delivers green work via the mode you pick at start (commit + push to main per task, or one PR per task), tries hard to resolve failures, reports in the morning.

**Click Notes — meetings & memory** (in [`skills/clicknotes/`](skills/clicknotes/README.md))
- `clicknotes-meeting` — improve a meeting's notes from its transcript and generate its tasks (deduped).
- `clicknotes-memory` — create/update a block in the company knowledge graph, following its conventions.
- `clicknotes-recall` — search the knowledge graph for the current topic and ground the conversation.
- `clicknotes-tasks` — reconcile open tasks against what's actually done (mark done / update partial).

**Issues & PRDs**
- `to-issues`, `to-prd`, `triage`.

**Engineering**
- `tdd`, `improve-codebase-architecture`, `diagnose`, `zoom-out`, `prototype`.

See [NOTICE.md](NOTICE.md) for which skills are Matt Pocock's and which are Pedro's.

## Install

Skills are folders with a `SKILL.md`. Point your agent's skills directory at them. For Claude Code, symlink each into your skills dir:

```bash
git clone https://github.com/pvieira-design/pedro-mota-skills.git
cd pedro-mota-skills
# symlink every skill (top-level and nested, e.g. skills/clicknotes/*) into ~/.claude/skills
find skills -name SKILL.md | while read -r f; do
  d=$(dirname "$f"); ln -sfn "$PWD/$d" ~/.claude/skills/"$(basename "$d")"
done
```

Then invoke any skill as `/<skill-name>` (e.g. `/setup-pedro-mota`). Start a new repo with `/setup-pedro-mota`.

> `sync-doc` is shipped as a skill here; in some setups it lives as a command (`~/.claude/commands/sync-doc.md`). Either works.

## License

MIT — see [LICENSE](LICENSE). Original skills © Matt Pocock; additions/adaptations © Pedro Mota.
