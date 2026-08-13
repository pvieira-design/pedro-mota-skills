---
name: implement
description: Implement exactly one executable issue from the configured tracker after verifying it is open, AFK-ready, unassigned and unblocked; ground in the parent spec and durable docs, claim first, test, document, review and close with evidence.
disable-model-invocation: true
---

# Implement

Implement **one issue per clean session**. The issue tracker, labels and delivery policy come from `docs/agents/`; the approved implementation contract comes from the parent GitHub spec.

## 1. Verify the frontier before mutation

Read `AGENTS.md`, `CLAUDE.md` and `docs/agents/engineering-workflow.md`. Fetch the issue plus labels, assignees, parent and native blockers. Continue only when it is:

- open;
- labelled `ready-for-agent`;
- unassigned;
- blocked by no open issue;
- an executable child, not a `spec` or `wayfinder:*` decision artifact.

If any condition fails, report it and do not claim or code.

The current session chat and internal Orca messages are approved channels for sensitive values needed by the task. GitHub, versioned files, commits, publishable patches and public logs are external: never copy secrets, credentials, PII or raw sensitive payloads into them. Persist only non-sensitive consequences or safe references; do not block or invent an indirect handoff merely because the value must move between the two approved channels.

## 2. Claim first

The first tracker mutation is assigning the issue to the current user. The assignee is the concurrency lock. Record the starting SHA with `git rev-parse HEAD` for the later review boundary.

Choose Git topology separately from the clean-session requirement. Default simple, bounded work to the repository's canonical local branch even when unrelated paths are dirty; preserve them and stage only explicit issue paths. A collision on an intended path requires a handoff, wait or a justified worktree — never overwrite, stash, reset or clean another task's work.

Create a worktree only for material isolation value. Before doing so, record the reason, owner, base SHA, expected paths, integration method and stop condition on the issue. A worktree is temporary and the task is not complete until its commit is integrated and the worktree/branch are removed.

## 3. Ground and audit the contract

Before code, read the complete issue, parent spec and every pointed feature-doc/ADR/learning. Start with `docs/system/README.md`, the target feature-doc and complementary feature-docs. Inspect only the code paths the docs identify until verification requires more.

Stop without coding when the parent spec is absent/thin, a criterion is ambiguous, a product/architecture decision remains open, a test seam is unspecified or a verification command cannot run. Comment the precise gap, remove the assignee and route to `needs-info` or `ready-for-human` according to the repo workflow.

## 4. Implement surgically

Use `tdd` at the seams agreed in the spec and issue. Work red → green in narrow vertical slices. Preserve unrelated working-tree changes. Run the focused checks required by the issue. A repository-wide suite runs only when the ticket/spec assigns that gate to this final candidate; do not repeat it per child by ritual.

Persist proof as command + scope + SHA + environment + result. Reuse a valid green proof for the same bytes and environment instead of rerunning it. Before browser/E2E work, prove the server URL, port, PID, cwd and HEAD match the candidate under test; reuse the correct server rather than opening another by reflex.

Do not expand scope. Record a deferred edge case as a GitHub issue with `to-pending`; do not silently solve it inside this issue.

## 5. Document, commit and review

1. Run `sync-doc` for every affected feature so `docs/system/` matches the new code.
2. Stage only explicit paths owned by this issue and create one local atomic commit.
3. Run `code-review <starting-SHA>` against the committed diff. Fix Standards and Spec findings, update the commit and rerun affected checks.
4. Do not push unless the user or issue explicitly authorizes it.

## 6. Prove and close

Verify every acceptance criterion individually. Comment on the issue with:

- concise delivery summary;
- criterion-by-criterion proof;
- exact commands and results;
- commit SHA and whether it is only local or published;
- any remaining remote/human gate.

Close only when the repository's delivery policy allows it. If blocked after claiming, comment the blocker and remove the assignee; never leave a zombie claim. Close the parent spec only after every child and global expectation is proven.

Stop as soon as the issue criteria are proven, required checks are green and review has no blocker. Adjacent investigation or optional improvement becomes a separate issue; it does not delay delivery.
