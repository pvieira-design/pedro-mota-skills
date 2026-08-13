# Pedro Mota Skills — repository instructions

This repository publishes a curated Agent Skills bundle for Claude Code and Codex. It combines Matt Pocock foundations with Pedro Mota's docs-first planning and execution workflow.

## Structure

- `skills/<name>/SKILL.md` — one publishable skill per top-level folder.
- `skills/<name>/agents/openai.yaml` — Codex UI/invocation metadata; required for every skill.
- `docs/` — installation, workflow, project-instruction and migration tutorials.
- `scripts/audit-installation.sh` — read-only user/project scope audit.
- `scripts/install-engineering-core.sh` — reproducible two-source global installer pinned to Matt v1.2.3 and an immutable Pedro commit.
- `index.html` — visual tutorial; must agree with `README.md` and `docs/`.
- `NOTICE.md` — per-family provenance and adaptation policy.

## Workflow invariants

- Install the explicit engineering-core profile once globally: pinned Matt foundations first, then the Pedro workflow overlay; do not teach `--skill '*'` or simultaneous user + project copies of the same name.
- `AGENTS.md` is the shared project instruction source; `CLAUDE.md` imports it with `@AGENTS.md`.
- Before the first grill/Wayfinder question, ground in `docs/system/README.md`, target and complementary feature-docs, then vocabulary, ADRs, learnings, related tracker work and pending issues.
- A standalone `grill-with-docs` creates a `grill:session` + `ready-for-human` issue before its first substantive question. Its body is the live checkpoint; each substantive round is preserved as a chronological comment before the checkpoint advances.
- Wayfinder uses its tracker map, decision tickets and resolution comments. Neither entry path creates a local grill file.
- `to-spec` reads the complete source issue history — body, every comment and linked artifact — so a clean or compacted session can publish the contract without relying on chat memory.
- Canonical flow: `standalone grill or Wayfinder → to-spec → spec issue → to-tickets → executable child issues → implement`.
- Approved work flows `to-spec → to-tickets → implement one issue per clean session → sync-doc → review/proof → tracker closure`.
- `grill-with-docs`, `wayfinder` and `to-tickets` are model-discoverable but preserve their confirmation/publication gates; `to-spec`, `implement`, `improve-codebase-architecture` and `setup-*` are user-invoked only.
- Tracker setup verifies fixed spec/pending/Wayfinder labels and configured triage roles.
- Click Notes and the removed `to-tasks`/`do-task`/`night-shift` branch are not part of this engineering distribution.

## Editing skills

- Keep changes surgical and preserve upstream attribution.
- When adapting a Matt skill, record the adaptation in `NOTICE.md`.
- Keep frontmatter `name` equal to the directory name and write precise trigger descriptions.
- Preserve Claude's `disable-model-invocation: true` and Codex's `policy.allow_implicit_invocation: false` together for explicitly invoked workflow skills.
- Keep supporting detail in referenced files instead of bloating `SKILL.md`.
- If a workflow rule changes, update the skill behavior, setup templates, `README.md`, relevant `docs/`, `index.html`, and active global copy together.

## Validation

Before handing off changes:

```bash
npx skills add . --list
npx html-validate index.html
./scripts/audit-installation.sh
bash -n scripts/install-engineering-core.sh
git diff --check
```

Also validate every `SKILL.md` frontmatter and every `agents/openai.yaml`, confirm all skill resource links resolve, test an isolated global install for both `codex` and `claude-code`, and search for stale workflow names.

Do not push or publish unless the user explicitly asks.
