---
name: setup-matt-pocock-skills
description: Configure a GitHub repository for the engineering skills — verify its workflow and triage labels, domain doc layout, and shared AGENTS.md/CLAUDE.md bridge. Run once before first use of the other engineering skills.
disable-model-invocation: true
---

# Setup Matt Pocock's Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — GitHub Issues, the operational queue used by this distribution
- **Triage labels** — the strings used for the five canonical triage roles
- **Workflow labels** — the fixed labels used by Wayfinder, specs and deferred work
- **Domain docs** — where `CONTEXT.md` and ADRs live, and the consumer rules for reading them

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

The current session chat and internal Orca messages are approved channels for sensitive values needed by setup. GitHub, generated repository files, commits, publishable patches and public logs are external: write only non-sensitive configuration consequences or safe references, never secrets, credentials, PII or raw sensitive payloads.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config` — which GitHub repo is this?
- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/` — does this skill's prior output already exist?
- Existing tracker labels — on GitHub, inspect with `gh label list --limit 200`; identify missing or conflicting workflow labels.
- Is the `triage` skill installed? (a `triage` skill folder alongside this one, or `triage` in your available skills.) This decides whether Section B runs at all.
- Monorepo signals — a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or a populated `packages/*` with its own `src/`. Present only in a genuinely large multi-package repo; their absence means single-context, which is almost every repo.

### 2. Present findings and ask

Summarise what's present and what's missing. Then take the sections in order — one section, one answer, then the next.

Lead each section with the recommended answer so the user can accept it in a word. Give a one-line explainer only when the choice genuinely branches; skip the section entirely when exploration already settled it (Section B when `triage` isn't installed, Section C when there's no monorepo).

**Section A — Issue tracker.**

> Explainer: this distribution uses GitHub Issues as the durable operational queue for grills, Wayfinder maps, specs, implementation tickets and pending work.

Confirm that the repository has a GitHub remote and that `gh` can read it. If either is missing, report the blocker; do not silently fall back to local markdown or another tracker. Record the repository in `docs/agents/issue-tracker.md` from the GitHub template. Leave "PRs as a request surface" off unless the user explicitly asks to change it.

**Section B — Triage label vocabulary.** Skip this section entirely if the `triage` skill isn't installed (exploration told you) — an uninstalled skill needs no labels.

If it is installed, ask exactly one question:

> Do you want to keep the default triage labels? (recommended: **yes**)

The defaults are the five canonical roles, each label string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. On **yes**, write them as-is. Only if the user says no — usually because their tracker already uses other names (e.g. `bug:triage` for `needs-triage`) — collect the overrides so `triage` applies existing labels instead of creating duplicates.

**Section C — Workflow labels.** These names are protocol, not customizable display preferences: `pending`, `grill:session`, `spec`, `wayfinder:map`, `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, and `wayfinder:task`. Together with the triage roles above, they are what `grill-with-docs`, `to-pending`, `wayfinder`, `to-spec`, `to-tickets`, and `implement` query.

- On GitHub, show which are present and which are missing. After the user confirms the setup draft, create only the missing labels; never overwrite the color/description of an existing label silently.
- If an existing label with one of these exact names has an incompatible meaning, stop and resolve the conflict with the user.

**Section D — Domain docs.** Default to **single-context** — one `CONTEXT.md` + `docs/adr/` at the repo root. This fits almost every repo; write it without asking.

Offer **multi-context** — a root `CONTEXT-MAP.md` pointing to per-context `CONTEXT.md` files — only when exploration found monorepo signals. Then confirm which layout they want.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, `docs/agents/workflow-labels.md`, and `docs/agents/triage-labels.md` (the last only when `triage` is installed)
- The exact missing remote labels that will be created, including color and description

Let them edit before writing.

### 4. Write

**Use one shared instruction source:** update/create root `AGENTS.md`. Ensure root `CLAUDE.md` begins with `@AGENTS.md`, retaining only Claude-specific additions below it. If a legacy repo has all shared instructions duplicated in `CLAUDE.md`, preserve them until the user-approved write, then move the shared `## Agent skills` block to `AGENTS.md` and rely on the import. Do not keep two independent copies.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Workflow labels

Spec, grill, pending and Wayfinder labels are fixed and verified on GitHub. See `docs/agents/workflow-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

Include the `### Triage labels` sub-block, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. Always include `### Workflow labels` and write `docs/agents/workflow-labels.md`.

After writing the docs, create only missing labels on a real tracker. For GitHub, use `gh label create <name> --color <hex> --description <text>` once per missing label. Do not use `--force` on existing labels. Re-list labels afterward and verify the complete required set.

Then write the docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker
- [triage-labels.md](./triage-labels.md) — label mapping (only if `triage` is installed)
- [workflow-labels.md](./workflow-labels.md) — fixed spec/Wayfinder/deferred-work label protocol
- [domain.md](./domain.md) — domain doc consumer rules + layout

### 5. Done

Tell the user the setup is complete, which labels were verified/created, that shared instructions live in `AGENTS.md` through the `CLAUDE.md` bridge, and which engineering skills read these files. Mention they can edit `docs/agents/*.md` directly later.
