# Attribution and provenance

This repository is a curated Pedro overlay of Agent Skills under the MIT License. Its installer first selects an explicit profile from [Matt Pocock's skills](https://github.com/mattpocock/skills) at `v1.2.3`, then applies Pedro Mota's original skills and workflow-specific adaptations.

## Matt Pocock foundations

The following are included as upstream or near-upstream engineering primitives:

- `codebase-design`
- `diagnose`
- `domain-modeling`
- `prototype`
- `research`
- `tdd`
- `to-spec`
- `triage`

The following originate from Matt Pocock's package but are intentionally adapted in this distribution:

- `code-review` — preserves the Standards and Spec axes while running both passes sequentially in the current agent, without delegation;
- `grilling` and `grill-with-docs` — docs-first grounding plus a genuine-decision gate before Pedro's tracker-backed, compaction-safe standalone grill;
- `wayfinder` — docs-first grounding and tracker-only trail;
- `setup-matt-pocock-skills` — cross-agent project instructions plus workflow-label verification;
- `to-spec` — on explicit publication intent, accepts a decision-complete direct brief or tracker trail and publishes a non-executable `spec` parent contract without inventing an empty grill;
- `to-tickets` — requires an approved GitHub spec, then publishes a reviewed tracer-bullet child queue;
- `implement` — one frontier issue per clean session, claim-first, committed implementation review, post-review `sync-doc`, final code-plus-docs review and evidence gates;
- `handoff` — rewritten as a direct-session alternative compatible with standalone grilling and Wayfinder;
- `improve-codebase-architecture` — retained as an explicit, read-only architecture audit rather than an automatically invoked implementation aid.
- `research` — preserves the upstream primary-source workflow while enforcing the approved sensitive-channel boundary for its persisted report.

These adaptations mean the same-named files are not guaranteed to match current upstream byte-for-byte. Update upstream deliberately; never overwrite this bundle blindly.

## Pedro Mota additions

- `setup-pedro-mota` — repository knowledge-base bootstrap and the complete docs/skills/tracker workflow;
- `to-pending` — GitHub-first deferred loose-end lifecycle using the `pending` label;
- `sync-doc` — living feature documentation synchronized with real code.

Pedro's distribution also supplies Codex `agents/openai.yaml` metadata, cross-agent installation guidance, `AGENTS.md`/`CLAUDE.md` conventions, workflow labels and migration documentation.

## Installation relationship

Use `scripts/install-engineering-core.sh` so Matt's pinned profile is installed first and Pedro's same-named adaptations are installed second. Reversing that order replaces the adaptations.

If redistributed, keep this notice and [LICENSE](LICENSE).
