---
name: grill-with-docs
description: Run a docs-grounded, one-decision-at-a-time interview for bounded work, preserving a compaction-safe live trail in a GitHub `grill:session` issue before promoting the closed decisions through `to-spec`. Use when a product, design, or architecture decision fits one interactive session. If inferred rather than explicitly requested, propose entering the grill and wait for confirmation.
---

# Grill With Docs

Close the decisions for bounded work without implementing it. The tracker issue is the session memory; a fresh session must be able to resume from it without chat history.

## 1. Confirm and ground

If the user did not explicitly invoke this skill, explain why a grill fits and wait for confirmation.

Before the first question, read the repository instructions, `docs/system/README.md`, target and complementary feature docs, relevant `CONTEXT.md`, ADRs, learnings, related tracker work and pending issues. Inspect only the code needed to verify facts. Summarize established facts, existing seams and genuine unknowns; ask the user only for decisions.

Verify the tracker protocol documents `grill:session`, `ready-for-human` and `spec`. If it does not, stop and use `setup-matt-pocock-skills`; do not invent labels.

The current session chat and internal Orca messages are approved channels for sensitive values needed by the work. GitHub is not: issue bodies/comments receive only non-sensitive consequences or safe references, never secrets, credentials, PII or raw sensitive payloads. Do not block or invent an indirect handoff merely because the value must move between the two approved channels.

## 2. Create the live checkpoint

After grounding and before the first substantive question, create one issue titled `[Grill] <specific topic>` with `grill:session` + `ready-for-human`. Keep this body current:

```markdown
## Objective

## Grounding sources and established facts

## Do

## Do not

## Decisions

## Open questions

## Discarded hypotheses

## Next checkpoint
```

Do not create or update `docs/grills/`; existing files there are historical only.

## 3. Grill one decision at a time

Run the `grilling` process and use `domain-modeling` where vocabulary or durable decisions need it. After every substantive answer:

1. add a chronological comment containing the new findings and the user's answer, explicitly classifying facts, decisions, hypotheses, preferences and remaining doubts;
2. update the issue body so it represents the current checkpoint;
3. only then ask the next decision.

This ordering is mandatory: compaction between questions must not erase the last round.

Move durable vocabulary to `CONTEXT.md` and hard-to-reverse, surprising trade-offs to ADRs. `docs/system/` changes only after code changes.

## 4. Hand off to the spec

The grill is decision-complete only when `Open questions` contains no blocking product, design, architecture, contract, UX, test-seam or failure-mode choice. Comment a final readiness summary and give the user the issue URL with the next action: invoke `to-spec` on that issue.

Keep the grill open until `to-spec` publishes the spec. `to-spec` then comments the spec link and closes the grill issue.
