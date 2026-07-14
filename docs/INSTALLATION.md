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

## Global install from GitHub

```bash
npx skills add pvieira-design/pedro-mota-skills \
  --global \
  --agent codex claude-code \
  --skill '*' \
  --yes
```

The important flag is `--global`. Running inside a Git repository without it installs a project copy.

## Global install from a local clone

Useful while developing this bundle:

```bash
git clone https://github.com/pvieira-design/pedro-mota-skills.git
cd pedro-mota-skills
npx skills add . \
  --global \
  --agent codex claude-code \
  --skill '*' \
  --yes
```

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

## Fix duplicate Personal + Project entries

First prove the overlap:

```bash
npx skills list --json
npx skills list --global --json
```

If the project versions are identical to the global versions and are not intentionally pinned, remove only this bundle's project copies:

```bash
npx skills remove \
  code-review codebase-design diagnose domain-modeling \
  grill-with-docs grilling handoff implement prototype research \
  setup-matt-pocock-skills setup-pedro-mota sync-doc tdd \
  to-pending to-plan to-spec to-tickets triage wayfinder \
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

## Do not stack the Matt package over this bundle

This distribution already contains a curated snapshot of Matt Pocock's skills, including Pedro-specific adaptations to grounding, labels and execution. Installing `mattpocock/skills` afterward can replace same-named skills and remove those adaptations.

Choose one:

- install this full distribution; or
- install Matt's upstream package and manually add only Pedro-only skills, accepting a different workflow.

The documented workflow assumes the first option.

## Update

For a GitHub-installed bundle:

```bash
npx skills update --global
```

Then rerun the audit and inspect the changelog/diff. When updating the vendored Matt snapshot in this repository, reapply Pedro adaptations deliberately and validate every skill before publishing.

## Bootstrap each repository

Once installation is clean:

- Claude Code: `/setup-pedro-mota`
- Codex: `$setup-pedro-mota`

The setup creates the repository knowledge base, configures labels/tracker docs, writes shared instructions to `AGENTS.md`, and creates a small `CLAUDE.md` that imports `@AGENTS.md`.
