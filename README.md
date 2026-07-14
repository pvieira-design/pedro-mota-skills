# Pedro Mota Skills

A curated, cross-agent engineering workflow for **Claude Code and Codex**, built from Matt Pocock's open-source skills plus Pedro Mota's documentation, planning and execution conventions.

The goal is simple: the agent should understand the existing system before asking questions or touching code, turn decisions into an executable contract, and close work with evidence and living documentation.

## Install once, globally

Use one user-scoped installation for both agents:

```bash
npx skills add pvieira-design/pedro-mota-skills \
  --global \
  --agent codex claude-code \
  --skill '*' \
  --yes
```

This creates one canonical user-level copy under `~/.agents/skills`. Codex discovers that location directly; Claude Code receives links under `~/.claude/skills` to the same skills.

Do **not** run the same command without `--global` inside every project. A same-named project copy under `.agents/skills` and user copy under `~/.agents/skills` makes Codex show both — for example, `Wayfinder · CRM` and `Wayfinder · Personal`. Claude Code gives the personal copy precedence, which can silently hide a different project version.

See [Installation and duplicate cleanup](docs/INSTALLATION.md) for local-clone installation, verification, updates and migration from duplicated installs.

## Invoke in each agent

| Action | Claude Code | Codex |
| --- | --- | --- |
| Select a skill | `/wayfinder` | `$wayfinder` or `/skills` |
| Bootstrap a repo | `/setup-pedro-mota` | `$setup-pedro-mota` |
| Publish tickets | `/to-tickets` | `$to-tickets` |
| Implement one issue | `/implement` | `$implement` |

The workflow and files are identical. Only explicit invocation syntax differs.

## Configure a repository

After the global install, open the target repository and run `setup-pedro-mota` once.

It creates or completes:

| Artifact | Question it answers |
| --- | --- |
| `AGENTS.md` | What every coding agent must know and do |
| `CLAUDE.md` | Claude bridge: `@AGENTS.md` plus Claude-only additions |
| `CONTEXT.md` | What the domain words mean |
| `docs/adr/` | Why hard-to-reverse decisions were made |
| `docs/system/` | What the code does today — living feature docs |
| `docs/plans/` | What is approved to build next |
| `docs/pending/` | What was deliberately deferred |
| `docs/learnings/` | Which non-obvious mistakes must not repeat |
| `docs/grills/` | Live trail of explicit standalone grillings only |
| `docs/agents/` | Tracker, labels, domain layout and full engineering workflow |

For GitHub repositories, authenticate `gh` first. The setup verifies and creates only missing workflow labels: `plan`, `spec`, `wayfinder:map`, `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, `wayfinder:task`, plus the configured triage labels.

## The mandatory grounding gate

Before the first question in a grill or Wayfinder — and before coding — the agent must:

1. Read `docs/system/README.md` and its topic map.
2. Read the target feature-doc and adjacent/complementary feature-docs.
3. Read relevant `CONTEXT.md`, ADRs, learnings, plans and pending items.
4. Summarize established facts, existing seams and genuine unknowns.
5. Ask the user only for decisions the repository cannot answer.

This is the core Pedro layer on top of the Matt skills: exploration begins from the project's living knowledge base, not from a blind codebase scan.

## The workflow

```text
bounded uncertainty                         large / foggy effort
        │                                           │
        ▼                                           ▼
grill-with-docs                                wayfinder
standalone docs/grills trail            tracker map + decision tickets
        └──────────────────────┬────────────────────┘
                               ▼
                            to-plan
                  approved AFK-ready contract
                               ▼
                           to-tickets
             root plan issue + blocked tracer children
                               ▼
                           implement
                  one frontier issue per clean session
                               ▼
             tdd → checks → sync-doc → commit → code-review
                               ▼
                proof → close → to-plan done
```

Important boundaries:

- `grill-with-docs` creates one timestamped `docs/grills/` file and updates it live.
- `wayfinder` does **not** create a local grill. Its map, tickets and resolution comments are the operational trail.
- `to-plan` consumes closed decisions and must leave no product/architecture choices for the executor.
- `to-tickets` requires an approved plan and asks for decomposition approval before tracker mutation.
- `implement` claims exactly one open, unassigned, unblocked `ready-for-agent` issue before editing.
- `sync-doc` updates `docs/system/` after code changes; `docs/system/` is project/feature memory, not `docs/grills/`.

Read the complete [engineering workflow](docs/WORKFLOW.md).

## How Pedro's and Matt's skills connect

Matt Pocock's skills provide the engineering primitives: Wayfinder, grilling, domain modeling, research, prototypes, tracer tickets, implementation, TDD, review and triage.

Pedro's layer turns those primitives into one repository lifecycle:

- `setup-pedro-mota` installs the living knowledge base and cross-agent instructions;
- `to-plan`, `to-pending` and `sync-doc` define the future/pending/present lifecycle;
- adapted Matt skills enforce docs-first grounding, tracker labels, one-ticket execution and evidence-based closure;
- `handoff` remains a direct-session alternative when a tracker queue is unnecessary.

This repository is a **curated distribution**, not something to install on top of a separate same-named Matt installation. Several Matt skills are included with Pedro-specific adaptations. Installing `mattpocock/skills` afterward can overwrite those names. See [Attribution and upstream policy](NOTICE.md).

## Skill catalog

### Setup and project memory

- `setup-pedro-mota`
- `setup-matt-pocock-skills`
- `sync-doc`
- `to-plan`
- `to-pending`
- `handoff`

### Decisions and design

- `grilling`
- `grill-with-docs`
- `wayfinder`
- `domain-modeling`
- `research`
- `prototype`
- `codebase-design`

### Queue and execution

- `to-spec`
- `to-tickets`
- `triage`
- `implement`
- `tdd`
- `code-review`
- `diagnose`

## Project instruction best practice

Keep cross-agent facts in `AGENTS.md`. Keep `CLAUDE.md` small:

```markdown
@AGENTS.md

## Claude Code

<!-- Only genuinely Claude-specific instructions belong here. -->
```

Put always-needed project facts in `AGENTS.md`, detailed repeatable procedures in skills, and feature state in `docs/system/`. Avoid copying the same long instructions into both root files. See [AGENTS.md and CLAUDE.md](docs/PROJECT-INSTRUCTIONS.md).

## Existing repositories

Use the ready-to-paste [migration prompt](docs/MIGRATION-PROMPT.md) to update projects that already received an older version of this documentation. It covers the new `docs/grills/` boundary, Wayfinder's tracker-only trail, the docs-first hard gate, labels, the issue-driven loop and cross-agent instruction layout.

## Update and verify

```bash
npx skills update --global
npx skills list --global --json
./scripts/audit-installation.sh
```

The audit is read-only. Inside a repository, it reports same-named project/user skills that would appear twice in Codex.

## Further reading

- [Installation](docs/INSTALLATION.md)
- [Workflow](docs/WORKFLOW.md)
- [Project instructions](docs/PROJECT-INSTRUCTIONS.md)
- [Migration prompt](docs/MIGRATION-PROMPT.md)
- [Visual tutorial](index.html)
- [Attribution](NOTICE.md)

## License

MIT — see [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md).
