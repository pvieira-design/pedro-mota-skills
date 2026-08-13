# Installation for Claude Code and Codex

## Recommended topology

Use one canonical copy per skill name and scope:

```text
~/.agents/skills/<name>          canonical user skill
        │
        ├── Codex discovers it directly
        └── ~/.claude/skills/<name> points to the same skill for Claude Code
```

Codex scans repository `.agents/skills` and user `~/.agents/skills`. If both contain the same `name`, Codex does not merge them and can display both in its selector. Claude Code scans `.claude/skills` and gives a personal skill precedence over a same-named project skill. Both behaviors make duplicate scopes a bad default for a reusable bundle.

Official references: [Codex skills](https://learn.chatgpt.com/docs/build-skills.md) and [Claude Code skills](https://code.claude.com/docs/en/skills).

## Reproducible engineering-core install

```bash
git clone https://github.com/pvieira-design/pedro-mota-skills.git
cd pedro-mota-skills
./scripts/install-engineering-core.sh <published-40-character-commit-sha>
```

The script installs exactly two ordered profiles:

1. 24 approved Matt skills from immutable tag `mattpocock/skills@v1.2.3`;
2. 13 Pedro-owned or adapted overlays from the immutable commit passed as the argument.

Both commands use `--global`, `--agent codex claude-code` and explicit skill names. There is no `--skill '*'` default profile.

## Project-scoped development fixture

Useful only while developing and validating this overlay before publication. Run it from a temporary directory, pointing at the clone:

```bash
skills_fixture_dir="$(mktemp -d)"
cd "$skills_fixture_dir"
npx skills add /path/to/pedro-mota-skills \
  --agent codex claude-code \
  --skill code-review grill-with-docs handoff implement \
    improve-codebase-architecture research setup-matt-pocock-skills \
    setup-pedro-mota sync-doc to-pending to-spec to-tickets wayfinder \
  --yes
```

That command installs a project-scoped fixture because it intentionally omits `--global`; do not use a dirty local checkout as team distribution proof.

## Verify

```bash
npx skills list --global --json
```

Then, from a normal project:

```bash
npx skills list --json
```

For this reusable bundle, the project list should not repeat the same names shown globally. Run the repository's read-only audit:

```bash
/path/to/pedro-mota-skills/scripts/audit-installation.sh
```

In Claude Code, use `/skills` to inspect sources. In Codex, use `/skills` or type `$` in the composer. Newly changed skills are normally detected live; restart the app if a stale selector remains.

### Workflow invocation policy

- Model or user invoked: `grill-with-docs`, `wayfinder`, `to-tickets`.
- User invoked only: `to-spec`, `implement`, `improve-codebase-architecture`, `setup-pedro-mota`, `setup-matt-pocock-skills`.

Implicit discovery does not bypass operational gates: grill/Wayfinder wait for confirmation, and `to-tickets` publishes only after an explicit user request.

## Fix duplicate Personal + Project entries

First prove the overlap:

```bash
npx skills list --json
npx skills list --global --json
```

If the project versions are identical to the global versions and are not intentionally pinned, remove only this bundle's project copies:

```bash
npx skills remove \
  code-review codebase-design diagnose domain-modeling improve-codebase-architecture \
  grill-with-docs grilling handoff implement prototype research \
  setup-matt-pocock-skills setup-pedro-mota sync-doc tdd \
  to-pending to-spec to-tickets triage wayfinder \
  --yes
```

Run that command **inside the affected project** and without `--global`. It must not be used if the repository intentionally owns a different same-named version. In that case choose the project version and remove/disable the corresponding user skill instead.

After removal:

```bash
npx skills list --json
./scripts/audit-installation.sh
```

Restart Codex if the old selector entry remains cached.

## When project scope is appropriate

Install under `.agents/skills` only when a skill is genuinely repo-specific or the team intentionally pins and versions it with the repository. Do not vendor a reusable global bundle in every project merely to share project instructions; project behavior belongs in `AGENTS.md`, `docs/agents/` and `docs/system/`.

If a project-scoped version intentionally replaces a global one, do not leave both active under the same frontmatter `name`.

## Preserve the overlay order

The explicit installer intentionally starts from Matt v1.2.3 and then replaces only the adapted names with Pedro's revision. Installing Matt again afterward can replace those names and remove the workflow adaptations.

Re-run `install-engineering-core.sh <same-or-new-published-sha>` when repairing provenance. Do not improvise the order or add all 35 upstream skills.

## Update

Because the engineering core is pinned, updating to a new Pedro revision is an explicit reinstall with the new published SHA:

```bash
./scripts/install-engineering-core.sh <new-published-40-character-commit-sha>
```

Then rerun the audit and inspect the changelog/diff. `npx skills update --global` only refreshes each skill at its recorded ref; it does not choose a new immutable Pedro revision for the team. When updating the pinned Matt version in this repository, reapply Pedro adaptations deliberately and validate every skill before publishing.

## Bootstrap each repository

Once installation is clean:

- Claude Code: `/setup-pedro-mota`
- Codex: `$setup-pedro-mota`

The setup creates the repository knowledge base, configures labels/tracker docs, writes shared instructions to `AGENTS.md`, and creates a small `CLAUDE.md` that imports `@AGENTS.md`.
