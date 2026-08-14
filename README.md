# Pedro Mota Skills

A curated, cross-agent engineering workflow for **Claude Code and Codex**, built from Matt Pocock's open-source skills plus Pedro Mota's documentation, specification and execution conventions.

The goal is simple: the agent should understand the existing system before asking questions or touching code, publish decisions as an executable GitHub contract, and close work with evidence and living documentation.

## Install the engineering core once, globally

The approved catalog combines Matt Pocock's pinned upstream skills with Pedro's workflow overlay. Use the repository installer with an immutable published commit SHA:

```bash
git clone https://github.com/pvieira-design/pedro-mota-skills.git
cd pedro-mota-skills
./scripts/install-engineering-core.sh <published-40-character-commit-sha>
```

The script installs an explicit 24-skill Matt profile from `mattpocock/skills@v1.2.3`, then overlays only the 13 Pedro-owned or deliberately adapted skills from the supplied immutable revision. It does not install every skill exposed by either repository.

The result is one canonical user-level copy under `~/.agents/skills`. Codex discovers that location directly; Claude Code receives links under `~/.claude/skills` to the same skills.

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
| GitHub Issues labelled `spec` | What is approved to build next |
| GitHub Issues labelled `pending` | What was deliberately deferred |
| `docs/learnings/` | Which non-obvious mistakes must not repeat |
| GitHub Issues labelled `grill:session` | Live, compaction-safe trail of standalone grillings |
| `docs/agents/` | Tracker, labels, domain layout and full engineering workflow |

Authenticate `gh` first. The setup verifies and creates only missing workflow labels: `pending`, `grill:session`, `spec`, `wayfinder:map`, `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`, `wayfinder:task`, plus the configured triage labels.

## The mandatory grounding gate

Before choosing a decision process, asking its first question, mutating its tracker trail or coding, the agent must:

1. Read `docs/system/README.md` and its topic map.
2. Read the target feature-doc and adjacent/complementary feature-docs.
3. Read relevant `CONTEXT.md`, ADRs, learnings, specs/tickets and pending items.
4. Summarize established facts, existing seams and genuine unknowns.
5. Ask the user only for decisions the repository cannot answer.

This is the core Pedro layer on top of the Matt skills: exploration begins from the project's living knowledge base, not from a blind codebase scan.

## The workflow

```text
simple + decided ────────────────────────────────→ direct work

decision-complete brief ─────────────────────────┐
bounded uncertainty → grill-with-docs ───────────┼→ to-spec → to-tickets
multisession + real fog → wayfinder ─────────────┘              │
                                                                 ▼
                                                     one issue per clean session
                                                                 │
                               tdd → focused checks → commit → code-review
                                                                 │
                                            sync-doc → final review → proof/closure
```

Important boundaries:

- `grill-with-docs` creates a `grill:session` + `ready-for-human` issue only after grounding proves at least one genuine decision remains. The body is the current checkpoint; comments preserve every substantive round.
- `wayfinder` keeps its map, tickets and resolution comments as the operational trail. Neither path creates a local grill.
- `to-spec` publishes only after an explicit request. It accepts either a complete direct brief in the current session or a tracker-backed grill/map read in full, then produces a contract that leaves no executor-facing choices.
- `to-tickets` requires an approved spec. An explicit request to publish tickets authorizes the skill to self-review and create the child decomposition without an intermediate approval round.
- `implement` claims exactly one open, unassigned, unblocked `ready-for-agent` issue before editing.
- `sync-doc` updates `docs/system/` after code changes; tracker issues hold planning-session history, not present-state documentation.

Read the complete [engineering workflow](docs/WORKFLOW.md).

## How Pedro's and Matt's skills connect

Matt Pocock's skills provide the engineering primitives: Wayfinder, grilling, domain modeling, research, prototypes, tracer tickets, implementation, TDD, review and triage.

Pedro's layer turns those primitives into one repository lifecycle:

- `setup-pedro-mota` installs the living knowledge base and cross-agent instructions;
- `to-spec` and `sync-doc` separate future tracker contracts from present repository docs; `to-pending` keeps deferred work in GitHub Issues;
- adapted Matt skills enforce docs-first grounding, tracker labels, one-ticket execution and evidence-based closure;
- `handoff` remains a direct-session alternative when a tracker queue is unnecessary.

This repository is the **Pedro overlay**, while the installer owns the order: pinned Matt profile first, Pedro adaptations second. Do not reinstall Matt afterward, because that would overwrite the workflow-specific copies. See [Attribution and upstream policy](NOTICE.md).

## Overlay catalog

The default Pedro overlay installs exactly these 13 names after the Matt profile:

- `code-review`
- `grill-with-docs`
- `handoff`
- `implement`
- `improve-codebase-architecture` (manual only)
- `research`
- `setup-matt-pocock-skills`
- `setup-pedro-mota`
- `sync-doc`
- `to-pending`
- `to-spec`
- `to-tickets`
- `wayfinder`

This source repository also keeps comparison/reference copies of `codebase-design`, `diagnose`, `domain-modeling`, `grilling`, `prototype`, `tdd` and `triage`. They are not selected by `install-engineering-core.sh`; the default profile gets the approved upstream names, including `diagnosing-bugs`, directly from Matt v1.2.3.

## Invocation policy

| Workflow skill | Codex | Claude Code | Operational gate |
| --- | --- | --- | --- |
| `grill-with-docs` | Model or user | Model or user | If inferred, propose the session and wait for confirmation |
| `wayfinder` | Model or user | Model or user | If inferred, explain why the work exceeds one grill and wait for confirmation |
| `to-spec` | Model or user | Model or user | Discovery is automatic; publication requires an explicit request and a decision-complete direct brief, grill or Wayfinder map |
| `to-tickets` | Model or user | Model or user | Tracker publication still requires an explicit user request |
| `implement` | User only | User only | One executable child issue in a clean session |
| `improve-codebase-architecture` | User only | User only | Read-only architecture audit; never inferred during normal implementation |
| `setup-*` | User only | User only | Mutates repository structure/configuration |

Model invocation controls discovery, not authority: HITL sessions still require confirmation, and tracker publication still requires an explicit request.

## Project instruction best practice

Keep cross-agent facts in `AGENTS.md`. Keep `CLAUDE.md` small:

```markdown
@AGENTS.md

## Claude Code

<!-- Only genuinely Claude-specific instructions belong here. -->
```

Put always-needed project facts in `AGENTS.md`, detailed repeatable procedures in skills, and feature state in `docs/system/`. Avoid copying the same long instructions into both root files. See [AGENTS.md and CLAUDE.md](docs/PROJECT-INSTRUCTIONS.md).

## Existing repositories

Use the ready-to-paste [migration prompt](docs/MIGRATION-PROMPT.md) to update projects that already received an older version of this documentation. It covers the direct/grill/Wayfinder routing boundary, the docs-first hard gate, labels, the issue-driven loop and cross-agent instruction layout.

## Update and verify

```bash
./scripts/install-engineering-core.sh <new-published-40-character-commit-sha>
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
