# Lessons learned (`docs/learnings/`)

**Lessons from mistakes already made** — traps, bugs with non-obvious causes, decisions that went wrong, and rework. Each file records **one** mistake and, above all, **the rule not to repeat it**. It's the institutional memory of "we already stepped on this rake".

> **Read before touching an area; write after getting bitten.** When you (or an agent) spend time on a bug with a hidden cause, a tool/environment trap, or a path that looked right and wasn't — record it here. The cost of writing 10 lines now is far less than the next person falling into the same hole.

## When to record a lesson

Record when **all** are true:

1. **It cost time / caused rework** — it wasn't obvious or immediate.
2. **It will recur** — someone else (or future-you) tends to fall in again.
3. **There's an actionable rule** — you can write "next time, do X / never do Y".

If it's just a code detail, that's a feature doc (`docs/system/`), not a lesson.

## Difference from sibling folders

| | `docs/learnings/` | `docs/system/` | `docs/plans/` |
|---|---|---|---|
| Captures | **mistake + rule not to repeat** | current state of the code | what we're going to do |
| Tone | "don't do X because Y" | "the code does X" | "we'll do X" |

## Naming convention

`YYYY-MM-DD-short-title.md` (lesson date + slug). E.g. `2026-06-13-git-add-in-shared-tree.md`.

## Structure of a lesson

Use [`_template.md`](_template.md). In one line: **What went wrong · Why · The rule (what to do/not do) · How to detect/signals**.

## Lessons

- _(none yet)_
