---
name: to-tickets
description: Publish an approved docs/plans implementation plan as one non-executable tracking issue plus blocked tracer-bullet child tickets, after proving every plan criterion belongs to exactly one ticket and the user approves the decomposition.
disable-model-invocation: true
---

# To Tickets

Turn one **approved implementation plan** into the configured tracker queue. In repositories using Pedro's docs structure, refuse to publish from a loose conversation, a thin tracker spec or an undecided plan. Return to `grill-with-docs`, `wayfinder` or `to-plan` first.

The tracker and label protocol must exist in `docs/agents/issue-tracker.md`, `triage-labels.md` and `workflow-labels.md`. Run `setup-matt-pocock-skills` if they are missing.

## 1. Read the contract

Read root instructions, `docs/agents/engineering-workflow.md`, the full plan, every ADR/feature-doc/learning/pending item it cites and the relevant `docs/system/README.md` topic map. Verify that:

- the plan status is approved/ready to implement;
- no decision, placeholder or “TBD” remains;
- paths, contracts, failure modes, UX states and verification commands are precise;
- Definition of Done criteria are atomic and verifiable.

If the plan fails this gate, identify exact gaps and stop without creating tracker items.

## 2. Draft vertical tracer bullets

Split the plan into narrow, complete end-to-end slices. Each child:

- delivers observable behavior through the required layers;
- fits one fresh agent context;
- can remain green when landed;
- declares native blocking edges;
- owns a unique subset of the plan's criteria;
- is AFK (`ready-for-agent`) or declares the exact human checkpoint (`ready-for-human`).

Do not create horizontal “database”, “API”, and “UI” tickets for one behavior. For mechanical wide refactors, use expand → migrate batches → contract, keeping intermediate states valid.

## 3. Coverage gate and approval

Before any tracker mutation, show:

- root issue title and plan path;
- each child title, mode, end-to-end delivery and blockers;
- the exact plan criteria owned by each child;
- a blocking graph or ordered frontier.

Check both directions: every plan criterion belongs to **exactly one** child, and every child deliverable traces to the plan. Ask the user to approve the decomposition. Iterate until approved.

## 4. Publish in two passes

### Pass A — create

1. Create one root tracking issue labelled `plan`. It points to `docs/plans/<file>.md`, summarizes the destination and lists global completion conditions. It never receives `ready-for-agent`.
2. Create one issue per child with the template below.
3. Attach every child to the root using native sub-issue relationships when supported.

### Pass B — wire

After every issue has an identifier, add native blocking relationships. Use a textual `Blocked by` fallback only when the tracker lacks native dependencies. Verify the resulting frontier: open, unassigned AFK children whose blockers are all closed.

## Child template

```markdown
## Source of truth

- Plan: `docs/plans/<file>.md` → section <n>
- Feature docs: `docs/system/feature-<name>.md`
- ADRs/learnings: <relevant links>

## What to deliver

<observable end-to-end behavior>

## Mode

AFK | HITL: <exact human checkpoint>

## Acceptance criteria

- [ ] <atomic criterion owned only by this ticket>

## Verification

- `<focused command>`
- `<repository-wide required command>`

## Invariants

- <what must not break or change>
```

Be pointer-first: do not paste the full plan, but include enough for selection and proof in a clean session. Paths and symbols are appropriate when they are canonical plan anchors; avoid speculative code snippets.

## 5. Report

Return the root and child links by title, their dependency/frontier state, label/mode and criterion coverage count. The next step is one fresh `implement` session per frontier issue.
