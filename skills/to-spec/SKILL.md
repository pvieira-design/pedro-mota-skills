---
name: to-spec
description: Publish decision-complete work as a self-contained, non-executable GitHub `spec` issue. Use when the user explicitly asks to create or publish a spec from a completed grill, a resolved Wayfinder map, or a direct brief that already contains every executor-facing decision. Never invent an intermediate grill merely to satisfy an origin gate.
---

# To Spec

Turn decision-complete work into the implementation contract. This is synthesis, not another interview.

## 1. Require publication intent and choose the source

Publishing a GitHub issue requires an explicit user request. If this skill was inferred from work that merely looks ready for a spec, propose publication and wait; loading the skill is not authorization to mutate the tracker.

Accept exactly one source:

- a standalone issue labelled `grill:session`; or
- a Wayfinder issue labelled `wayfinder:map`; or
- a direct brief in the current session whose product, design, architecture, scope, UX, contracts, failure modes and verification decisions are already closed.

The direct-brief path is a fast path for already-decided work, not a substitute for discovery. Use it only when the brief is fully present in the current context and grounding reveals no executor-facing choice. If any genuine decision remains, stop before mutation, explain the gaps and propose the appropriate grill or Wayfinder path. Never create an empty `grill:session` as plumbing for this skill.

Refuse a loose conversation that is still exploring options, a local plan, a local grill file or an untracked summary from another session.

## 2. Read the complete history

Read repository instructions and the configured tracker docs.

For a tracker-backed source, fetch the source body, every comment and every linked artifact.

For a Wayfinder map, also read every resolved child decision ticket and its resolution comments. Stop if any child decision remains open, fog remains unresolved or the destination is not ready to specify.

For a direct brief, read the complete current-session request and constraints. Do not rely on absent earlier chat, an agent's recollection or a summary that omits the exact decisions.

Ground the synthesis in `docs/system/README.md`, target and complementary feature docs, `CONTEXT.md`, ADRs, learnings and related pending issues. Use current code only to verify facts and exact anchors.

The current session chat and internal Orca messages are approved channels for sensitive values needed by the work. The GitHub spec is external: preserve only non-sensitive consequences or safe references, never secrets, credentials, PII or raw sensitive payloads. Do not invent a redaction ceremony between the two approved channels.

## 3. Completeness gate

Do not publish while any executor-facing choice remains. The selected source must settle:

- problem, expected outcome, scope and non-goals;
- product, architecture and data decisions;
- exact contracts, permissions, required fields, failure modes and invariants;
- frontend layout, actions, states and edge states when applicable;
- public test seams, verification commands and observable acceptance criteria;
- risks, discarded alternatives and prohibited behavior.

If anything is missing or contradictory, report the exact gaps and stop. For a tracker-backed source, also comment the gaps on that issue. Do not fill them from inference or ask a new interview inside this skill.

## 4. Publish the parent contract

Create one unassigned issue labelled only `spec` among workflow/state labels. Never apply `ready-for-agent` or `ready-for-human` to the spec.

```markdown
## Origin

- Decision trail: <source issue link, or `Direct brief explicitly approved in the current session`>

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

After the spec exists, comment its link on a tracker-backed source and close the completed grill or Wayfinder map. A direct brief has no intermediate issue to close. Return the spec link and state that the next step is `to-tickets`.
