---
name: implement
description: Implement exactly one executable issue from the configured tracker after verifying it is open, AFK-ready, unassigned and unblocked; ground in the linked plan/docs, claim first, test, document, review and close with evidence.
disable-model-invocation: true
---

# Implement

Implement **one issue per clean session**. The issue tracker, labels and delivery policy come from `docs/agents/`; the approved implementation contract comes from the linked `docs/plans/` file.

## 1. Verify the frontier before mutation

Read `AGENTS.md`, `CLAUDE.md` and `docs/agents/engineering-workflow.md`. Fetch the issue plus labels, assignees, parent and native blockers. Continue only when it is:

- open;
- labelled `ready-for-agent`;
- unassigned;
- blocked by no open issue;
- an executable child, not a `plan`, `spec` or `wayfinder:*` decision artifact.

If any condition fails, report it and do not claim or code.

## 2. Claim first

The first tracker mutation is assigning the issue to the current user. The assignee is the concurrency lock. Record the starting SHA with `git rev-parse HEAD` for the later review boundary.

## 3. Ground and audit the contract

Before code, read the complete issue, complete linked plan and every pointed feature-doc/ADR/learning. Start with `docs/system/README.md`, the target feature-doc and complementary feature-docs. Inspect only the code paths the docs identify until verification requires more.

Stop without coding when the plan is absent/thin, a criterion is ambiguous, a product/architecture decision remains open, a test seam is unspecified or a verification command cannot run. Comment the precise gap, remove the assignee and route to `needs-info` or `ready-for-human` according to the repo workflow.

## 4. Implement surgically

Use `tdd` at the seams already agreed in the plan. Work red → green in narrow vertical slices. Preserve unrelated working-tree changes. Run focused tests and typechecking regularly, then all checks required by the issue at the end.

Do not expand scope. Record a deferred edge case with `to-pending`; do not silently solve it inside this issue.

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

Close only when the repository's delivery policy allows it. If blocked after claiming, comment the blocker and remove the assignee; never leave a zombie claim. Close the root `plan` issue and run `to-plan done` only after every child and global criterion is proven.
