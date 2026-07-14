# Engineering workflow: docs + skills + issue tracker

This is the detailed operating manual for turning uncertain work into verified code without losing decisions or forcing an autonomous executor to invent answers. Adapt tracker commands and verification commands to the repository; keep the state model and gates intact.

## Mental model

| Layer | Responsibility | Must not become |
| --- | --- | --- |
| `docs/` | Durable truth: language, decisions, current system, plans, loose ends and lessons | Operational queue/status |
| Skills | Process: discover, decide, plan, decompose, implement and review | Product source of truth |
| Issue tracker | Shared queue: hierarchy, blockers, claims, handoffs and proof | Full duplicate of plans/docs |
| Code + tests | Executable reality | Historical rationale |

Golden rule: **the issue points to the truth; it does not duplicate it**.

## Skill installation scope

Install reusable skills once at user scope. Codex discovers `~/.agents/skills`; Claude Code discovers `~/.claude/skills`, which should point to that same canonical copy. Do not also install the same skill names under the repository's `.agents/skills`/`.claude/skills`, because Codex can display both repo and user entries.

Use repo-scoped skills only when they are genuinely specific to that repository or intentionally pin a team version. In that case, do not keep a same-named global copy active.

Shared project instructions live in `AGENTS.md`. Root `CLAUDE.md` imports them with `@AGENTS.md` and contains only Claude-specific additions.

## 1. Choose the right entry

| Situation | Entry | Result |
| --- | --- | --- |
| Bounded work with decisions to close | `grill-with-docs` | Confirmed understanding + standalone grill trail |
| Large, greenfield or too foggy for one session | `wayfinder` | Tracker map of decision tickets; no duplicate local grill |
| Missing external fact | `research` | Cited finding linked to the requesting ticket |
| Behavior/visual still too abstract | `prototype` | Disposable artifact that improves the decision |
| All decisions are closed | `to-plan` | Executable plan under `docs/plans/` |
| Approved plan must become a queue | `to-tickets` | Root `plan` issue + vertical child tickets |
| One AFK child is on the frontier | `implement` | One implemented, verified and documented slice |

Do not use Wayfinder for small work. Do not ask the user for facts that docs/code can answer. Do not use a tracker spec to skip the detailed local plan.

## 2. Ground before the first question or mutation

This is a hard gate for both `grill-with-docs` and `wayfinder`, and before coding:

1. Read `docs/system/README.md` and its topic map.
2. Read the target `feature-*.md` and adjacent/complementary feature-docs whose rules, APIs or state interact with the work.
3. Read `CONTEXT.md` and cited ADRs.
4. Check relevant `docs/learnings/`, `docs/plans/` and `docs/pending/`.
5. For a resumed standalone grill, read its prior `docs/grills/` session file.
6. Summarize established facts, existing seams and genuine unknowns.
7. Only then inspect the specific code paths named by those docs.

If docs disagree with code, code defines the present and `sync-doc` must correct the docs. If a new decision contradicts an ADR, make the reopening explicit.

## 3. Decide

### Standalone grilling

`grill-with-docs` creates one `docs/grills/YYYY-MM-DD-HHmm-<topic>.md` before its first question and updates it live. Ask one decision at a time. Durable vocabulary moves to `CONTEXT.md`; hard-to-reverse, surprising trade-offs move to ADRs; future execution moves to a plan. `docs/system/` changes only after code changes.

### Wayfinder

Wayfinder plans work too large for one decision session. Its destination is normally an AFK-ready plan. The tracker is its canonical trail:

- `wayfinder:map` — destination, decisions index, fog and out-of-scope;
- `wayfinder:research` — AFK external fact;
- `wayfinder:prototype` — HITL concrete artifact;
- `wayfinder:grilling` — HITL decision;
- `wayfinder:task` — manual work that unblocks a decision.

Wayfinder does **not** create a file in `docs/grills/`. Resolve at most one non-research ticket per session. Put the detailed answer in the ticket resolution comment and only a linked one-line gist in the map.

## 4. Make the plan AFK-ready

`to-plan` writes the canonical implementation contract under `docs/plans/`. It is ready only when:

- there are no placeholders, “maybe”, “TBD”, or implicit decisions;
- models, FKs, enums, required fields, permissions, contracts and failure modes are exact;
- frontend work defines layout, actions, states and edge states;
- changes point to real paths/symbols;
- invariants and prohibited alternatives are explicit;
- public test seams are agreed;
- verification commands are copyable;
- every Definition of Done item is atomic and verifiable;
- every change maps to criteria and every criterion maps to exactly one change;
- relevant ADRs, feature docs, learnings and pending items are cited;
- out-of-scope work is explicit.

If any gate fails, return to grilling, research or prototype. Do not make the implementation ticket choose.

## 5. Publish the queue

`to-tickets` accepts an approved plan. Before tracker mutation, show the decomposition, blocking graph and criterion coverage; wait for approval.

- Create one root issue labelled `plan`, pointing to `docs/plans/<file>.md`; it is not executable.
- Create one child per narrow end-to-end tracer bullet.
- Use native sub-issue and blocking relationships where available.
- Apply `ready-for-agent` only to AFK slices; use `ready-for-human` for a human checkpoint.
- Assign every plan criterion to exactly one ticket.

Each ticket should be pointer-first but sufficient for a clean session: plan + section, relevant feature docs/ADRs/learnings, end-to-end delivery, AFK/HITL mode, atomic criteria, exact verification commands, blockers and invariants.

## 6. Frontier and claim

An implementation ticket is takeable only when it is open, labelled `ready-for-agent`, unassigned and has no open blockers. The assignee is the logical lock. The first mutation in `implement` is claiming the ticket. If work cannot continue, comment the precise blocker, remove the claim and route it to `needs-info` or `ready-for-human`.

## 7. Implement one ticket in a clean session

1. Verify frontier status and claim the issue.
2. Record the starting SHA for the review boundary.
3. Read the full issue, full plan and all pointed docs before code.
4. Refuse AFK execution if a decision, criterion, seam or command is ambiguous.
5. Work red → green at the agreed seams; run focused checks regularly.
6. Run the required full suite at the end.
7. Run `sync-doc` for affected feature docs.
8. Commit only the issue's explicit paths; do not push unless authorized.
9. Run `code-review <starting-SHA>` over the committed diff; fix findings and rerun affected checks.
10. Verify every criterion individually and collect proof.
11. Comment summary, criterion proofs, commands/results, commit and remaining gates.
12. Close only according to the repository's delivery policy.

A green test suite alone does not prove the whole plan was delivered.

## 8. Complete the plan

Close the root issue only after all children and global criteria are proven. Run a final `sync-doc`, then `to-plan done <slug>`. Record deferred work with `to-pending` and recurring non-obvious traps in `docs/learnings/`.

## 9. Concurrency

The issue assignee is not a filesystem lock. In one physical checkout, allow only one writing/committing `implement` session at a time. Parallel implementation requires separate worktrees and branches; each session still claims its own issue. Preserve unrelated changes and stage explicit paths.

## Invocation syntax

- Claude Code: `/wayfinder`, `/to-tickets`, `/implement`.
- Codex: `$wayfinder`, `$to-tickets`, `$implement` (or choose them through `/skills`).

The workflow and artifact names are the same; only the explicit invocation syntax differs.
