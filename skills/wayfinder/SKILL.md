---
name: wayfinder
description: Plan a huge chunk of work — more than one agent session can hold — after grounding in existing project docs, as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear.
---

A loose idea has arrived — too big for one agent session, and wrapped in fog: the way from here to the **destination** isn't visible yet. Wayfinding is about finding that way, not charging at the destination. This skill charts the way as a **shared map** on the repo's issue tracker, then works its **decision tickets** — questions whose resolution is a decision, not slices of a build to execute — one at a time until the route is clear.

If the user did not explicitly invoke Wayfinder, explain why the work exceeds one grill session and wait for confirmation before creating or changing tracker artifacts.

The destination varies per effort, but for this engineering distribution it normally ends in a decision-complete GitHub spec ready for `to-tickets`. Naming that destination is the first act of charting because it shapes every ticket.

## Plan, don't do

Wayfinder is **planning** by default: each ticket resolves a decision, and the map is done when the way is clear — nothing left to decide before someone goes and does the thing. The pull to just do the work is usually the signal you've reached the edge of the map and it's time to hand off. An effort can override this in its **Notes** — carrying execution into the map itself — but absent that, produce decisions, not deliverables.

## Ground before charting or questioning

Before the first question or tracker mutation in every invocation, read the repository's agent instructions and configured knowledge base. When `docs/system/README.md` exists, use its topic map to read the target feature-doc and the adjacent/complementary feature-docs whose rules, APIs or state interact with the destination; then read relevant `CONTEXT.md`, ADRs, learnings, related tracker work and pending issues. Inspect only the specific code paths named by those docs when facts need verification.

Briefly state the established behavior, existing seams and genuine unknowns before asking a decision. Never turn a repository fact into a question for the user.

Before the first tracker mutation, verify the configured tracker contains `wayfinder:map`, `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, and `wayfinder:task` as documented in `docs/agents/workflow-labels.md`. If the protocol or labels are missing, stop and run `setup-matt-pocock-skills`; do not improvise alternate names.

The map, tickets and resolution comments on the configured tracker are the canonical trail. Durable outcomes still flow to `CONTEXT.md`, ADRs and the final spec; `docs/system/` changes only after the code changes. Existing `docs/grills/` files are historical only.

The current session chat and internal Orca messages are approved channels for sensitive values needed by the work. GitHub is not: maps, tickets and comments receive only non-sensitive consequences or safe references, never secrets, credentials, PII or raw sensitive payloads. Do not block or invent an indirect handoff merely because the value must move between the two approved channels.

## Refer by name

Every map and ticket is an issue, so it has a **name** — its title. In everything the human reads — narration, the map's Decisions-so-far — refer to it by that name, never by a bare id, number, or slug. A wall of `#42, #43, #44` is illegible; names read at a glance. The id and URL don't vanish — a name wraps its link — but they ride *inside* the name, never stand in for it.

## The Map

The map is a single issue on this repo's issue tracker, labelled `wayfinder:map` — the canonical artifact. Its tickets are child issues of the map.

The map is an **index**, not a store. It lists the decisions made and points at the tickets that hold their detail; a decision lives in exactly one place — its ticket — so the map never restates it, only gists it and links.

The map, child tickets, blocking edges and frontier live in GitHub Issues. The repository-specific commands must be provided by `docs/agents/issue-tracker.md`; run `/setup-matt-pocock-skills` if that file is missing. Do not fall back to local markdown or another tracker.

### The map body

The whole map at low resolution, loaded once per session. Open tickets are **not** listed — they are open child issues, found by query.

```markdown
## Destination

<what reaching the end of this map looks like — the spec, decision, or change this effort is finding its way to. One or two lines; every session orients to it before choosing a ticket.>

## Grounding sources and established facts

## In scope

## Guardrails and out of scope

<domain; skills every session should consult; standing preferences for this effort>

## Decisions so far

<!-- the index — one line per closed ticket: enough to judge relevance, then zoom the link for the detail the ticket holds -->

- [<closed ticket title>](link) — <one-line gist of the answer>

## Not yet specified

<!-- see "Fog of war": in-scope fog you can't ticket yet; graduates as the frontier advances -->

## Next checkpoint

<!-- the next question or decision-ticket action -->
```

### Tickets

Each ticket is a **child issue** of the map; the tracker's issue id is its identity. Its body is the question, sized to one 100K token agent session:

```markdown
## Question

<the decision or investigation this ticket resolves>

## Type and mode

## Established facts

## Do

## Do not

## Current checkpoint

## Open questions

## Assets and safe references
```

Each ticket carries a `wayfinder:<type>` label — one of `research`, `prototype`, `grilling`, `task` (see [Ticket Types](#ticket-types)).

A session **claims** a ticket by assigning it to the dev driving the map, **first**, before any work, so concurrent sessions skip it. That assignee _is_ the claim: an open, unassigned ticket is unclaimed.

Blocking uses the tracker's **native** dependency relationship — essential because it renders the frontier _visually_ in the tracker's own UI, so the human sees what's takeable without opening the map. Only a tracker that lacks native blocking falls back to a body convention. A ticket is **unblocked** when every ticket blocking it is closed; the **frontier** is the open, unblocked, unclaimed children — the edge of the known.

The answer isn't part of the body — it's recorded on resolution (see [Work through the map](#work-through-the-map)). Assets created while resolving a ticket are linked from the issue, not pasted in.

## Ticket Types

Every ticket is either **HITL** — human in the loop, worked *with* a human who speaks for themselves — or **AFK**, driven by the agent alone. A HITL ticket only resolves through that live exchange; the agent never stands in for the human's side of it (a grilling agent that answers its own questions has broken this).

- **Research** (AFK): Reading documentation, third-party APIs, or local resources like knowledge bases to surface a fact a decision waits on. Resolved by a `/research` **subagent**. Use when knowledge outside the current working directory is required.
- **Prototype** (HITL): Raise the fidelity of the discussion by making a cheap, rough, concrete artifact to react to — an outline, a rough take, a stub, or UI/logic code via the /prototype skill. Links the prototype as an asset. Use when "how should it look" or "how should it behave" is the key question.
- **Grilling** (HITL): Conversation via the /grilling and /domain-modeling skills, one question at a time. The default case.
- **Task** (HITL or AFK): Manual work that must happen before a *decision* can be made — nothing to decide, prototype, or research, but the discussion is blocked until it's done. Signing up for a service so its API can be judged, provisioning access, moving data so its shape can be seen. This is the one type that *does* rather than decides — and it earns its place by unblocking a decision, not by delivering the destination. The agent drives it alone where it can (AFK); otherwise it hands the human a precise checklist (HITL). Resolved when the work is done; the answer records what was done and any resulting facts (credentials location, new URLs, row counts) later tickets depend on.

## Fog of war

The map is _deliberately_ incomplete: don't chart what you can't yet see. Beyond the live tickets lies the **fog of war** — the dim view of decisions and investigations you can tell are coming but can't yet pin down, because they hang on questions still open. Resolving a ticket clears the fog ahead of it, graduating whatever's now specifiable into fresh tickets — one at a time, until the way to the destination is clear and no tickets remain.

The map's **Not yet specified** section is where that dim view is written down: the suspected question, the area to revisit later. It's the undiscovered frontier _toward_ the destination — everything here is in scope, just not sharp enough to ticket. Write as loosely or as fully as the view allows; it doubles as a signpost for collaborators reading where the effort is headed.

**Fog or ticket?** The test is whether you can state the question precisely now — _not_ whether you can answer it now.

- **Ticket when** the question is already sharp — even if it's blocked and you can't act on it yet.
- **Not yet specified when** you can't yet phrase it that sharply. Don't pre-slice the fog into ticket-sized pieces: it's coarser than a ticket, and one patch may graduate into several tickets, or none, once the frontier reaches it.

**Not yet specified** excludes what's already decided (Decisions so far), what's already a live ticket, and what's out of scope (the next section).

## Out of scope

Fog only ever gathers _toward_ the destination. The destination fixes the scope, so work beyond it is **out of scope** — it isn't fog, and it doesn't belong in **Not yet specified**. It lives under **Guardrails and out of scope** on the map: work you've consciously ruled out of _this_ effort. Scope, not sharpness, lands it here.

Out-of-scope work never graduates — the frontier stops at the destination — so it returns only if the destination is redrawn, and then as a fresh effort, not a resumption.

Ruling something out of scope is a scoping act, not a step on the route. When a ticket that already exists turns out to sit past the destination — mis-scoped in while charting, or exposed by a resolution — **close it** (a closed ticket is unambiguously off the frontier) and leave one line under **Guardrails and out of scope**: the gist plus why it's out of scope, linking the closed ticket. It stays out of **Decisions so far**, which records the route actually walked — a scope boundary isn't a step on it.

## Invocation

Two modes. Either way, **never resolve more than one ticket per session** — with the exception of research tickets.

### Chart the map

User invokes with a loose idea.

1. **Name a provisional destination.** Establish enough scope to distinguish this effort from adjacent work. If the route is already clear and fits one session, stop before mutation and offer the smaller standalone-grill flow.
2. **Create the live map early** with label `wayfinder:map`, before the breadth-first charting questions. Mark provisional or unconfirmed statements explicitly; initialize Destination, grounding facts, in scope, guardrails/out of scope, Decisions-so-far, Not yet specified and Next checkpoint.
3. **Map the frontier breadth-first.** After every substantive answer, record the round in a map comment, explicitly classifying facts, decisions, hypotheses, preferences and remaining doubts, then update the body before asking again so compaction cannot erase the latest state.
4. **Create only tickets whose questions are already precise**, then wire blocking edges in a second pass. Everything still too vague remains in Not yet specified.
5. **Run eligible research tickets in parallel** when authorized and useful; each result lives in its ticket and only a linked gist reaches the map.
6. Stop — charting creates and updates the map but resolves no non-research decision ticket in the same session.

### Work through the map

User invokes with a map (URL or number). A ticket is **optional** — without one, you pick the next decision, not the user.

1. Load the **map** — the low-res view, not every ticket body.
2. Choose the ticket. If the user named one, use it. Otherwise take the first frontier ticket in order. **Claim it**: assign it to yourself before any work.
3. Resolve it — **zoom as needed**: fetch the full body of any related or closed ticket on demand; invoke the skills named by the map's grounding/guardrails. If in doubt, use `/grilling` and `/domain-modeling`. After every substantive HITL answer or material AFK finding, add a chronological comment and refresh the ticket checkpoint before continuing. Research, prototype and task tickets preserve facts, assets, limits and safe references without changing their modality into a grill.
4. Record the resolution: ensure the ticket body and final resolution comment represent the current state, **close** the issue, and **append a context pointer** to the map's Decisions-so-far before ending the response.
5. Add newly-surfaced tickets (create-then-wire); graduate any fog the answer has made specifiable, clearing each graduated patch from **Not yet specified** so it lives only as its new ticket. If the answer reveals a ticket — this one or another — sits beyond the destination, **rule it out of scope** rather than resolving it on the route. If the decision invalidates other parts of the map, update or delete those tickets.

When no decision ticket or unresolved fog remains, comment a readiness summary and hand the map URL to `to-spec`. Keep the map open until `to-spec` publishes the spec; `to-spec` then comments the link and closes the map.

The user may run unblocked tickets in parallel, so expect other sessions to be editing the tracker concurrently.
