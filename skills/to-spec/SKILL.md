---
name: to-spec
description: Publish a decision-complete standalone grill or resolved Wayfinder map as a self-contained, non-executable GitHub `spec` issue. Reads the complete tracker history and does not interview or rely on chat memory.
disable-model-invocation: true
---

# To Spec

Turn a completed tracker-backed decision process into the implementation contract. This is synthesis, not another interview.

## 1. Require a source issue

Require the URL or number of exactly one source:

- a standalone issue labelled `grill:session`; or
- a Wayfinder issue labelled `wayfinder:map`.

Refuse a loose conversation, local plan, local grill file or untracked summary. The source issue is the recovery boundary after compaction.

## 2. Read the complete history

Read repository instructions and the configured tracker docs. Fetch the source body, every comment and every linked artifact.

For a Wayfinder map, also read every resolved child decision ticket and its resolution comments. Stop if any child decision remains open, fog remains unresolved or the destination is not ready to specify.

Ground the synthesis in `docs/system/README.md`, target and complementary feature docs, `CONTEXT.md`, ADRs, learnings and related pending issues. Use current code only to verify facts and exact anchors.

The current session chat and internal Orca messages are approved channels for sensitive values needed by the work. The GitHub spec is external: preserve only non-sensitive consequences or safe references, never secrets, credentials, PII or raw sensitive payloads. Do not invent a redaction ceremony between the two approved channels.

## 3. Completeness gate

Do not publish while any executor-facing choice remains. The source must settle:

- problem, expected outcome, scope and non-goals;
- product, architecture and data decisions;
- exact contracts, permissions, required fields, failure modes and invariants;
- frontend layout, actions, states and edge states when applicable;
- public test seams, verification commands and observable acceptance criteria;
- risks, discarded alternatives and prohibited behavior.

If anything is missing or contradictory, comment the exact gaps on the source issue and stop. Do not fill them from inference or ask a new interview inside this skill.

## 4. Publish the parent contract

Create one unassigned issue labelled only `spec` among workflow/state labels. Never apply `ready-for-agent` or `ready-for-human` to the spec.

```markdown
## Origin

- Decision trail: <source issue link>

## Problem

## Expected outcome

## Scope

## Non-goals

## Decisions and exact technical contracts

## Frontend flow and states

## Invariants and failure modes

## Testing decisions and verification

## Risks and discarded alternatives

## Acceptance criteria

- [ ] <atomic, observable criterion>
```

Use exact repository paths and symbols when they are stable contract anchors. The issue must be sufficient for `to-tickets` and a clean implementation session without reading the original chat.

## 5. Close the decision trail

After the spec exists, comment its link on the source issue and close the completed grill or Wayfinder map. Return the spec link and state that the next step is `to-tickets`.
