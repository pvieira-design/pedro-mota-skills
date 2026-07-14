# Engineering workflow

## State model

```text
project truth       CONTEXT + ADRs + docs/system + learnings
future contract     docs/plans
operational queue   issue tracker
executable truth    code + tests
```

Issues point to canonical repository documents. They do not copy the whole plan.

## 1. Ground first

Before the first question in `grill-with-docs` or `wayfinder`, before their first tracker mutation, and before code:

1. open `docs/system/README.md`;
2. read target and complementary feature-docs;
3. read relevant vocabulary, ADRs, learnings, plans and pending items;
4. state established facts, seams and real unknowns;
5. inspect only the code paths needed to verify those facts.

The user decides product/design trade-offs. The repository answers repository facts.

## 2. Choose the decision process

Use `grill-with-docs` when decision work fits one session. It creates one timestamped file under `docs/grills/` before the first question and updates it live.

Use `wayfinder` when the effort is larger than one session or the route is too foggy. Wayfinder creates a tracker map and child decision tickets. It does **not** create a local grill: map, tickets and resolution comments are its operational memory.

Wayfinder ticket types:

- `research` — external fact, AFK;
- `prototype` — concrete artifact, HITL;
- `grilling` — user decision, HITL;
- `task` — manual step that unblocks a decision.

Resolve at most one non-research Wayfinder ticket in a session.

## 3. Write the executable contract

Use `to-plan` only after decisions close. The plan must be sufficient for an agent with no chat history. Exact contracts, data rules, failure modes, UX states, paths, public test seams, commands, invariants and atomic Definition of Done criteria belong there.

If the executor would have to choose, the plan is not ready.

## 4. Publish the queue

Use `to-tickets` on an approved plan. Before creating anything, show the root, tracer children, blockers and criterion ownership; wait for approval.

- root issue: `plan`, non-executable;
- children: vertical slices;
- dependencies: native blockers;
- AFK frontier: open + `ready-for-agent` + no assignee + no open blocker;
- HITL checkpoint: `ready-for-human`.

Every plan criterion belongs to exactly one child.

## 5. Implement one issue

Use a clean session and one `implement` invocation per child:

1. verify frontier status;
2. claim first;
3. read issue, full plan and linked docs;
4. stop if any decision/criterion/seam is ambiguous;
5. use TDD at agreed seams;
6. run focused and full checks;
7. run `sync-doc`;
8. make a local explicit-path commit;
9. run `code-review` from the starting SHA;
10. prove every criterion and comment the evidence;
11. close according to delivery policy.

No push unless explicitly authorized.

## 6. Close the plan

When every child and global criterion is proven:

1. close the root issue;
2. run a final `sync-doc`;
3. run `to-plan done <slug>`;
4. record deferred items with `to-pending`;
5. record recurring non-obvious traps in `docs/learnings/`.

## Labels

The setup verifies these fixed workflow labels:

`plan`, `spec`, `wayfinder:map`, `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, `wayfinder:task`.

Triage roles are configurable but default to:

`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`.

## Concurrency

The issue assignee is a logical claim, not a filesystem lock. One physical checkout may have only one writing/committing `implement` session. Parallel implementation requires separate worktrees and branches, with one claimed issue per session.

## Handoff

`handoff` is still available for a direct fresh-chat transfer when a tracker queue is unnecessary. It must point to canonical docs and, for Wayfinder, to the tracker map/ticket rather than inventing a local grill.
