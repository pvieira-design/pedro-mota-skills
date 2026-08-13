# Engineering workflow

`Standalone grill or Wayfinder → to-spec → spec issue → to-tickets → executable child issues → implement`

## State model

```text
project truth       CONTEXT + ADRs + docs/system + learnings
future contract     GitHub spec issue
operational queue   GitHub child issues
executable truth    code + tests
```

Implementation issues point to the parent spec and durable repository documents. They do not copy the whole contract.

The current session chat and internal Orca messages are approved channels for sensitive values needed by the work. GitHub, versioned files, commits, publishable patches and public logs are external: persist only non-sensitive consequences or safe references, never secrets, credentials, PII or raw sensitive payloads. Do not create an indirect handoff merely because a necessary value moves between the two approved channels.

## 1. Ground first

Before the first question in `grill-with-docs` or `wayfinder`, before their first tracker mutation, and before code:

1. open `docs/system/README.md`;
2. read target and complementary feature-docs;
3. read relevant vocabulary, ADRs, learnings, specs/tickets and pending items;
4. state established facts, seams and real unknowns;
5. inspect only the code paths needed to verify those facts.

The user decides product/design trade-offs. The repository answers repository facts.

## 2. Choose the decision process

Use `grill-with-docs` when decision work fits one session. After grounding and before the first substantive question, create `[Grill] <specific topic>` with `grill:session` + `ready-for-human`. Keep the current checkpoint in its body and preserve each substantive round as a chronological comment that distinguishes facts, decisions, hypotheses, preferences and doubts before asking the next question.

The checkpoint records objective, sources, established facts, scope, non-goals, decisions, open questions, discarded hypotheses and the next checkpoint. This issue is the recovery artifact after compaction or a clean-session handoff.

Use `wayfinder` when the effort is larger than one session or the route is too foggy. Wayfinder creates a tracker map and child decision tickets. It does **not** create a local grill: map, tickets and resolution comments are its operational memory.

Wayfinder ticket types:

- `research` — external fact, AFK;
- `prototype` — concrete artifact, HITL;
- `grilling` — user decision, HITL;
- `task` — manual step that unblocks a decision.

Resolve at most one non-research Wayfinder ticket in a session.

## 3. Publish the executable contract

Use `to-spec` only after decisions close. It reads the source grill/map body, every comment and linked artifact without relying on chat memory. The GitHub spec must preserve the problem, solution, behavior, implementation decisions, data rules, failure modes, UX states, test seams, invariants and out-of-scope boundaries.

If implementation tickets would have to choose product or architecture, the spec is not ready.

## 4. Publish the queue

Use `to-tickets` on the approved spec. The user's explicit request to publish tickets authorizes the skill to design, self-review and create the tracer bullets and blockers without an intermediate approval round. Stop only when the spec still leaves a product, scope or architecture decision open.

- parent issue: existing `spec`, non-executable;
- children: vertical slices;
- dependencies: native blockers;
- AFK frontier: open + `ready-for-agent` + no assignee + no open blocker;
- HITL checkpoint: `ready-for-human`.

Every spec behavior is covered exactly once across the children.

## 5. Implement one issue

Use a clean session and one `implement` invocation per child:

1. verify frontier status;
2. claim first;
3. read issue, parent spec and linked docs;
4. stop if any decision/criterion/seam is ambiguous;
5. use TDD at agreed seams;
6. run the focused checks assigned to the ticket; run a global suite only when this ticket is the repository's designated final candidate;
7. run `sync-doc`;
8. make a local explicit-path commit;
9. run `code-review` from the starting SHA;
10. prove every criterion and comment the evidence;
11. close according to delivery policy.

No push unless explicitly authorized.

## 6. Close the spec

When every child and global criterion is proven:

1. close the parent spec issue;
2. run a final `sync-doc`;
3. record deferred items as GitHub issues labelled `pending` with `to-pending`;
4. record recurring non-obvious traps in `docs/learnings/`.

## Labels

The setup verifies these fixed workflow labels:

`pending`, `grill:session`, `spec`, `wayfinder:map`, `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, `wayfinder:task`.

Triage roles are configurable but default to:

`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`.

## Concurrency

The issue assignee is a logical claim, not a filesystem lock. One physical checkout may have only one writing/committing `implement` session. Parallel implementation requires separate worktrees and branches, with one claimed issue per session.

## Handoff

`handoff` is still available for a direct fresh-chat transfer when a tracker queue is unnecessary. It must point to canonical docs and, for Wayfinder, to the tracker map/ticket rather than inventing a local grill.
