# Attribution and provenance

This repository is a curated distribution of Agent Skills under the MIT License. It combines a vendored snapshot of [Matt Pocock's skills](https://github.com/mattpocock/skills) with Pedro Mota's original skills and workflow-specific adaptations.

## Matt Pocock foundations

The following are included as upstream or near-upstream engineering primitives:

- `code-review`
- `codebase-design`
- `diagnose`
- `domain-modeling`
- `prototype`
- `research`
- `tdd`
- `to-spec`
- `triage`

The following originate from Matt Pocock's package but are intentionally adapted in this distribution:

- `grilling` and `grill-with-docs` — docs-first grounding and Pedro's standalone grill boundary;
- `wayfinder` — docs-first grounding and tracker-only trail (no duplicate `docs/grills/` file);
- `setup-matt-pocock-skills` — cross-agent project instructions plus workflow-label verification;
- `to-tickets` — requires an approved `docs/plans/` contract, coverage gate, root issue and child queue;
- `implement` — one frontier issue per clean session, claim-first, docs, review and evidence gates;
- `handoff` — rewritten as a direct-session alternative compatible with standalone grilling and Wayfinder.

These adaptations mean the same-named files are not guaranteed to match current upstream byte-for-byte. Update upstream deliberately; never overwrite this bundle blindly.

## Pedro Mota additions

- `setup-pedro-mota` — repository knowledge-base bootstrap and the complete docs/skills/tracker workflow;
- `to-plan` — confirmed decisions to an AFK-ready implementation contract, plus plan closure;
- `to-pending` — deferred loose-end lifecycle;
- `sync-doc` — living feature documentation synchronized with real code.

Pedro's distribution also supplies Codex `agents/openai.yaml` metadata, cross-agent installation guidance, `AGENTS.md`/`CLAUDE.md` conventions, workflow labels and migration documentation.

## Installation relationship

This repository already bundles the required Matt foundations. Do not install it and then install the same-named Matt package over it unless you intentionally want to replace Pedro's adaptations.

If redistributed, keep this notice and [LICENSE](LICENSE).
