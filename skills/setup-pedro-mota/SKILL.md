---
name: setup-pedro-mota
description: COMPLETE bootstrap of a repo's knowledge base in Pedro Mota's standard, so the AI is smart from day one. Creates/ensures CONTEXT.md (domain glossary), docs/adr/ (decisions + whys), docs/system/ (living technical docs), docs/plans/ (work plans), docs/pending/ (loose ends to revisit), docs/learnings/ (lessons from mistakes), runs Matt Pocock's agent setup (issue tracker/triage/domain in docs/agents/), and writes/updates CLAUDE.md explaining the importance and how each one works + the skill loop (/grill-with-docs, /to-plan, /to-pending, /sync-doc) plus the optional Click Notes MCP branch (/to-tasks, /do-task, /night-shift, /clicknotes-*). Run once per repo, before using the other skills, or whenever this structure is missing.
disable-model-invocation: true
---

# Setup Pedro Mota

Bootstraps the whole **knowledge base** that makes an agent (or person) productive from day one: they understand a feature by reading a page instead of scanning the code, **don't reopen decisions already made**, and **don't repeat mistakes already paid for**. Six artifacts, each answering a different question, + Matt Pocock's agent config:

- **`CONTEXT.md`** — *what the words mean* (domain glossary).
- **`docs/adr/`** — *why we decided it this way* (Architecture Decision Records).
- **`docs/system/`** — *what the code does TODAY* (living technical docs; one feature per file). Maintained by `/sync-doc`.
- **`docs/plans/`** — *what we're GOING to do* (work plans; ephemeral). Created by `/to-plan`.
- **`docs/pending/`** — *what's left open* (loose ends to revisit, so nothing is forgotten). Created by `/to-pending`.
- **`docs/learnings/`** — *where we already erred* (lessons not to repeat).
- **`docs/agents/`** — operational agent config (issue tracker, triage labels, domain layout), via `/setup-matt-pocock-skills`.

This is a **prompt-driven** skill, not a script. Explore → present what you found → confirm with the user → write. Be **idempotent**: only create what's missing, never overwrite the user's work, update blocks in-place.

> Folder/path names (`docs/system`, `docs/plans`, `docs/pending`, `docs/learnings`, `docs/adr`, `CONTEXT.md`) are Pedro's established conventions — keep them as-is even though this skill is written in English.

## Process

### 1. Explore

Understand the repo's current state (run in parallel):

- `ls docs/ docs/system/ docs/plans/ docs/pending/ docs/learnings/ docs/adr/ docs/agents/ 2>/dev/null` — what already exists?
- `ls CLAUDE.md AGENTS.md CONTEXT.md CONTEXT-MAP.md 2>/dev/null` — which root artifacts exist?
- `git remote -v` — GitHub/GitLab? (feeds Matt's issue-tracker setup).
- `git ls-files '*.md' | head -50` — docs convention already in use?
- Code layout: `ls`, `cat package.json pnpm-workspace.yaml 2>/dev/null` — monorepo? which apps/packages? (feeds the template's "Where it lives" and CLAUDE.md "Structure").

Read whatever exists before proposing — don't assume.

### 2. Present findings and confirm

Summarize in a few lines: which artifacts already exist (✅) and which are missing (⬜), whether there's a `CLAUDE.md`/`AGENTS.md`, the detected code layout, and the remote (for the issue tracker). State what you'll create and what you'll update in-place. **Confirm before writing.**

If a **different** docs structure already exists (e.g. `docs/features/`, `documentation/`), ask whether the user wants to migrate to this standard or keep it — don't impose.

### 3. Write the artifacts (only the missing ones)

Always adapt paths/layout to the repo (language, monorepo vs single app) — the seeds are generic.

**Vocabulary — `CONTEXT.md`** (at the root, if missing):
- ← seed [`context-seed.md`](./context-seed.md). Fill in the context name/description; the "Language" section starts empty (filled during grilling). For multi-context monorepos, consider `CONTEXT-MAP.md` (see `/grill-with-docs`'s format).

**Decisions — `docs/adr/`** (if missing):
- `docs/adr/_template.md` ← seed [`adr-template.md`](./adr-template.md).
- `docs/adr/README.md` ← seed [`adr-readme.md`](./adr-readme.md).
- `docs/adr/0001-knowledge-base-in-docs.md` ← seed [`adr-0001-seed.md`](./adr-0001-seed.md) (the first ADR records the very decision to keep this knowledge base — serves as a format example). If ADRs already exist, **don't** create 0001; just ensure README + template.

**System — `docs/system/`**:
- `docs/system/_template.md` ← seed [`system-template.md`](./system-template.md) (adjust "Where it lives" to the repo's real layers).
- `docs/system/README.md` ← seed [`system-readme.md`](./system-readme.md) (the "Topic map" table starts empty; `/sync-doc` fills it).

**Plans — `docs/plans/`**:
- `docs/plans/README.md` ← seed [`plans-readme.md`](./plans-readme.md).

**Pending — `docs/pending/`**:
- `docs/pending/_template.md` ← seed [`pending-template.md`](./pending-template.md).
- `docs/pending/README.md` ← seed [`pending-readme.md`](./pending-readme.md).

**Lessons — `docs/learnings/`**:
- `docs/learnings/_template.md` ← seed [`learnings-template.md`](./learnings-template.md).
- `docs/learnings/README.md` ← seed [`learnings-readme.md`](./learnings-readme.md).

If a folder exists but its README/template is missing, create only what's missing. Never clobber a user's file — suggest the additions instead.

### 4. Run Matt Pocock's agent setup

For the operational part (where issues live, triage label vocabulary, domain layout), **invoke `/setup-matt-pocock-skills`** — it creates `docs/agents/` + the `## Agent skills` block in CLAUDE.md. Don't reimplement it here; delegate (it's the source of truth for that dimension). If it's unavailable in the environment, say so and proceed without that part.

> Order: both this skill and Matt's edit CLAUDE.md, but in distinct sections and idempotently — running one after the other doesn't conflict. Run Matt's setup and then apply the blocks from step 5 (or vice versa), checking that no section is duplicated.

### 5. Write CLAUDE.md (or AGENTS.md)

**Pick the file:** if `CLAUDE.md` exists, edit it; else `AGENTS.md`; if neither, ask which to create. Never create one when the other already exists.

CLAUDE.md must **explain** the knowledge base — why each artifact matters and how it works (when to read, when to write, which skill maintains it) — not just list it. An agent that has never seen the repo should understand the role of `docs/` just by reading CLAUDE.md. Insert/update the four blocks from the seed [`claude-md-blocks.md`](./claude-md-blocks.md), **adapting the repo's real paths**:

1. **Structure** — short list (apps/packages + the docs artifacts with a one-liner).
2. **The `docs/` folder — why it matters and how it works** — the main block: one subsection per artifact (`CONTEXT.md`/`docs/adr`/`system`/`plans`/`pendencias`/`aprendizados`) with *what it is · why it matters · how it works*. **Don't cut this block** — it's the heart.
3. **The routine** — what to read before coding (incl. `CONTEXT.md`/ADR) and what to run when done (`/sync-doc`, `/to-plan done`, `/to-pending`, lesson).
4. **Skill ecosystem** — how `/setup-pedro-mota`, `/setup-matt-pocock-skills`, `/grill-with-docs`, `/to-plan`, `/to-pending` and `/sync-doc` fit into the loop, plus a **gated** subsection for the optional Click Notes MCP branch (`/to-tasks`, `/do-task`, `/night-shift`, `/clicknotes-*`) — keep it clearly marked "if your workspace uses the Click Notes MCP" so repos without it aren't confused.

**Idempotency:** if a block already exists (even worded differently), update it in-place instead of duplicating. Preserve what the user wrote around it.

### 6. Done

Tell the user, in ≤6 lines: which artifacts were created/ensured, which instructions file was edited, and the work loop now in effect: **`/grill-with-docs` (CONTEXT.md+ADR) → `/to-plan` → implement → `/sync-doc` → `/to-plan done`** (+ `/to-pending` for what you deferred, + a lesson if you got bitten). Remind them they can edit the `README.md`/`_template.md`/seeds directly afterward.

## Related skills (the ecosystem)

This skill **installs the knowledge base**; the others **consume and maintain it**:

- **`/setup-matt-pocock-skills`** — agent config (issue tracker, triage, domain) in `docs/agents/`. Called in step 4.
- **`/grill-with-docs`** / **`/grill-me`** — grilling that fixes vocabulary in `CONTEXT.md` and creates **ADRs** inline as decisions close.
- **`/to-plan`** — writes plans in `docs/plans/` (referencing relevant ADRs) and archives them in `done/` when implemented.
- **`/to-pending`** — records loose ends in `docs/pending/` (detailed) and resolves/promotes them.
- **`/sync-doc`** — keeps `docs/system/` in sync with the code (+ "Topic map") at the end of each feature.

**Optional — Click Notes MCP branch** (only if that MCP is connected; gate it as such in the generated CLAUDE.md):

- **`/to-tasks`** / **`/do-task`** / **`/night-shift`** — board-driven execution: publish a `docs/plans/` plan as gated Click Notes tasks (`[READY FOR DEV]`/`[PLANNING]`/`[WIP]`), then `/do-task` implements one (supervised) or `/night-shift` drains the whole board unattended (overnight, committing green work to main). An alternative to `/handoff` for passing a plan to a fresh agent.
- **`/clicknotes-meeting`** / **`/clicknotes-memory`** / **`/clicknotes-recall`** / **`/clicknotes-tasks`** — drive the company's meetings + knowledge graph + task board (see `skills/clicknotes/`).

Keep them coherent: if you change the structure here, adjust the references in those skills.
