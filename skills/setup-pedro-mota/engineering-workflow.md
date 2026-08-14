# Engineering workflow: docs + skills + issue tracker

This is the detailed operating manual for turning uncertain work into verified code without losing decisions or forcing an autonomous executor to invent answers. Adapt tracker commands and verification commands to the repository; keep the state model and gates intact.

## Mental model

| Layer | Responsibility | Must not become |
| --- | --- | --- |
| `docs/` | Durable truth: language, decisions, current system and lessons | Operational queue/status |
| Skills | Process: discover, decide, plan, decompose, implement and review | Product source of truth |
| Issue tracker | Future contracts and queue: specs, hierarchy, blockers, deferred loose ends, claims, handoffs and proof | Duplicate of durable docs |
| Code + tests | Executable reality | Historical rationale |

Golden rule: **the issue points to the truth; it does not duplicate it**.

Sensitive-data rule: the current session chat and internal Orca messages are approved channels for necessary secrets, credentials, PII and sensitive payloads. GitHub, versioned files, commits, publishable patches and public logs are external; they receive only non-sensitive consequences or safe references. Do not block or add an indirect handoff merely because a necessary value moves between the two approved channels.

Choose the smallest valid route: direct work for simple decided changes; direct brief → `to-spec`; standalone grill → `to-spec`; or Wayfinder → `to-spec`. Every spec then flows through `to-tickets` to executable child issues.

## Skill installation scope

Install reusable skills once at user scope. Codex discovers `~/.agents/skills`; Claude Code discovers `~/.claude/skills`, which should point to that same canonical copy. Do not also install the same skill names under the repository's `.agents/skills`/`.claude/skills`, because Codex can display both repo and user entries.

Use repo-scoped skills only when they are genuinely specific to that repository or intentionally pin a team version. In that case, do not keep a same-named global copy active.

Shared project instructions live in `AGENTS.md`. Root `CLAUDE.md` imports them with `@AGENTS.md` and contains only Claude-specific additions.

## 1. Choose the right entry

| Situation | Entry | Result |
| --- | --- | --- |
| Simple, decided, local, low-risk work | Current chat | Direct implementation without a planning issue |
| Decision-complete brief needing an AFK contract | `to-spec` | Direct approved spec without an intermediate grill |
| Bounded work with decisions to close | `grill-with-docs` | Confirmed understanding + live `grill:session` issue |
| Multisession planning with real route fog | `wayfinder` | Tracker map of decision tickets; no duplicate local grill |
| Missing external fact | `research` | Cited finding linked to the requesting ticket |
| Behavior/visual still too abstract | `prototype` | Disposable artifact that improves the decision |
| All decisions are closed | `to-spec` | Approved implementation contract on the tracker |
| Approved spec must become a queue | `to-tickets` | Vertical child tickets with blocking edges |
| One AFK child is on the frontier | `implement` | One implemented, verified and documented slice |

Zero open decisions means zero grill. Size alone does not justify Wayfinder. Do not ask the user for facts that docs/code can answer. Do not publish a spec while product or architecture decisions remain open.

## 2. Ground before the first question or mutation

This is a hard gate for both `grill-with-docs` and `wayfinder`, and before coding:

1. Read `docs/system/README.md` and its topic map.
2. Read the target `feature-*.md` and adjacent/complementary feature-docs whose rules, APIs or state interact with the work.
3. Read `CONTEXT.md` and cited ADRs.
4. Check relevant `docs/learnings/`, related specs/tickets and open GitHub issues labelled `pending`.
5. For a resumed standalone grill, read its issue body, every comment and linked artifact. Read `docs/grills/` only when an old reference points to that historical archive.
6. Summarize established facts, existing seams and genuine unknowns.
7. Only then inspect the specific code paths named by those docs.

If docs disagree with code, code defines the present and `sync-doc` must correct the docs. If a new decision contradicts an ADR, make the reopening explicit.

## 3. Decide

### Standalone grilling

After grounding, `grill-with-docs` first names at least one genuine executor-facing decision. If none remains, stop before tracker mutation and use direct work or a directly requested `to-spec`. Otherwise create `[Grill] <specific topic>` with `grill:session` + `ready-for-human` before the first substantive question. Its body is the live checkpoint: objective, sources, facts, scope, non-goals, decisions, open questions, discarded hypotheses and next checkpoint. After every substantive answer, add a chronological comment that distinguishes facts, decisions, hypotheses, preferences and doubts, then update the body before asking again. This makes the session recoverable after compaction or handoff.

Ask one decision at a time. Durable vocabulary moves to `CONTEXT.md`; hard-to-reverse, surprising trade-offs move to ADRs; `docs/system/` changes only after code changes. When no blocking decision remains, `to-spec` reads the complete issue history, publishes the spec, comments its link on the grill and closes the grill issue.

### Wayfinder

Wayfinder plans work that is both too large for one decision session and still foggy about the route. Its destination is normally an approved spec issue ready for decomposition. The tracker is its canonical trail:

- `wayfinder:map` — destination, decisions index, fog and out-of-scope;
- `wayfinder:research` — AFK external fact;
- `wayfinder:prototype` — HITL concrete artifact;
- `wayfinder:grilling` — HITL decision;
- `wayfinder:task` — manual work that unblocks a decision.

Wayfinder uses only its tracker trail. Resolve at most one non-research ticket per session. During a ticket session, persist every substantive answer or material finding in a chronological comment and refresh the ticket checkpoint before continuing. Put the detailed resolution in the ticket and only a linked one-line gist in the map.

## 4. Publish the implementation contract

`to-spec` requires explicit publication intent and accepts one decision-complete source: the direct brief fully present in the current session, a completed grill, or a resolved Wayfinder map. It reads tracker-backed sources in full, then publishes the closed decisions as the parent implementation contract. It is ready only when:

- there are no placeholders, “maybe”, “TBD”, or implicit decisions;
- models, FKs, enums, required fields, permissions, contracts and failure modes are exact;
- frontend work defines layout, actions, states and edge states;
- invariants and prohibited alternatives are explicit;
- public test seams are agreed;
- success is expressed through observable behavior and test decisions;
- relevant ADRs, feature docs, learnings and pending issues are linked;
- out-of-scope work is explicit.

If any gate fails, return to grilling, research or prototype. Do not make implementation tickets choose product or architecture.

## 5. Publish the queue

`to-tickets` accepts the approved spec issue. The user's explicit request to publish tickets authorizes it to design, self-review and create the decomposition and blocking graph without an intermediate approval round. Stop only when the spec still leaves a product, scope or architecture decision open.

- Keep the existing `spec` issue as the non-executable parent contract; do not create a second root.
- Create one child per narrow end-to-end tracer bullet.
- Use native sub-issue and blocking relationships where available.
- Apply `ready-for-agent` only to AFK slices; use `ready-for-human` for a human checkpoint.
- Cover every spec behavior exactly once across the child acceptance criteria.

Each ticket should be pointer-first but sufficient for a clean session: parent spec, relevant feature docs/ADRs/learnings, end-to-end delivery, AFK/HITL mode, atomic criteria, exact verification commands, blockers and invariants.

## 6. Frontier and claim

An implementation ticket is takeable only when it is open, labelled `ready-for-agent`, unassigned and has no open blockers. The assignee is the logical lock. The first mutation in `implement` is claiming the ticket. If work cannot continue, comment the precise blocker, remove the claim and route it to `needs-info` or `ready-for-human`.

## 7. Implement one ticket in a clean session

1. Verify frontier status and claim the issue.
2. Record the starting SHA for the review boundary.
3. Read the full issue, parent spec and all pointed docs before code.
4. Refuse AFK execution if a decision, criterion, seam or command is ambiguous.
5. Work red → green at the agreed seams; run focused checks regularly.
6. Run the focused checks assigned to the ticket. Run a global suite only when this ticket is the repository's designated final candidate; reuse valid proof for an identical SHA and environment.
7. Commit only the issue's explicit paths; do not push unless authorized.
8. Run `code-review <starting-SHA>` over the committed diff; fix findings and rerun affected checks.
9. Run `sync-doc` for affected feature docs after the implementation review.
10. Perform a final review of code and living docs together.
11. Verify every criterion individually and collect proof.
12. Comment summary, criterion proofs, commands/results, commit and remaining gates.
13. Close only according to the repository's delivery policy.

A green test suite alone does not prove the whole spec was delivered.

## 8. Complete the spec

Close the parent spec only after all children and global expectations are proven. Run a final `sync-doc`, record deferred work as GitHub issues labelled `pending` with `to-pending`, and record recurring non-obvious traps in `docs/learnings/`.

## 9. Concurrency

The issue assignee is not a filesystem lock. In one physical checkout, allow only one writing/committing `implement` session at a time. Parallel implementation requires separate worktrees and branches; each session still claims its own issue. Preserve unrelated changes and stage explicit paths.

## Invocation syntax

- Claude Code: `/wayfinder`, `/to-tickets`, `/implement`.
- Codex: `$wayfinder`, `$to-tickets`, `$implement` (or choose them through `/skills`).

The workflow and artifact names are the same; only the explicit invocation syntax differs.
