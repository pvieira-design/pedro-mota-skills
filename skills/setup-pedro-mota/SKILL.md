---
name: setup-pedro-mota
description: COMPLETE bootstrap of a repo's knowledge base in Pedro Mota's standard, so the AI is smart from day one. Creates/ensures CONTEXT.md, docs/adr/, docs/system/, docs/plans/, docs/pending/, docs/learnings/, docs/grills/ and docs/agents/; configures the Matt Pocock engineering skills; and keeps shared instructions in AGENTS.md with a CLAUDE.md bridge. Run once per repo, before using the other skills, or whenever this structure is missing.
disable-model-invocation: true
---

# Setup Pedro Mota

Bootstraps the whole **knowledge base** that makes an agent (or person) productive from day one: they understand a feature by reading a page instead of scanning the code, **don't reopen decisions already made**, and **don't repeat mistakes already paid for**. Seven artifacts, each answering a different question, + Matt Pocock's agent config:

- **`CONTEXT.md`** — *what the words mean* (domain glossary).
- **`docs/adr/`** — *why we decided it this way* (Architecture Decision Records).
- **`docs/system/`** — *what the code does TODAY* (living technical docs; one feature per file). Maintained by `/sync-doc`.
- **`docs/plans/`** — *what we're GOING to do* (work plans; ephemeral). Created by `/to-plan`.
- **`docs/pending/`** — *what's left open* (loose ends to revisit, so nothing is forgotten). Created by `/to-pending`.
- **`docs/learnings/`** — *where we already erred* (lessons not to repeat).
- **`docs/grills/`** — *how we reasoned in standalone grillings* (auxiliary session memory; one timestamped file per explicit `/grill-with-docs` session, no index). Wayfinder uses its tracker map/tickets/comments instead.
- **`docs/agents/`** — operational agent config (issue tracker, workflow/triage labels, domain layout and the full engineering workflow), via `/setup-matt-pocock-skills` plus this skill.

This is a **prompt-driven** skill, not a script. Explore → present what you found → confirm with the user → write. Be **idempotent**: only create what's missing, never overwrite the user's work, update blocks in-place.

Install one hard grounding rule: **before the first question in `/grill-with-docs` or `/wayfinder`**, read `docs/system/README.md`, the target feature-doc and the adjacent/complementary feature-docs named by its topic map, then relevant `CONTEXT.md`/ADRs. Summarize established facts and ask the user only for decisions the knowledge base and code cannot answer.

> Folder/path names (`docs/system`, `docs/plans`, `docs/pending`, `docs/learnings`, `docs/grills`, `docs/adr`, `CONTEXT.md`) are Pedro's established conventions — keep them as-is even though this skill is written in English.

## Process

### 1. Explore

Understand the repo's current state (run in parallel):

- `ls docs/ docs/system/ docs/plans/ docs/pending/ docs/learnings/ docs/grills/ docs/adr/ docs/agents/ 2>/dev/null` — what already exists?
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

**Grilling sessions — `docs/grills/`**:
- `docs/grills/_template.md` ← seed [`grills-template.md`](./grills-template.md) (per-session structure).
- Do **not** create `docs/grills/README.md`: navigation is the timestamped filename (`YYYY-MM-DD-HHmm-<detailed-slug>.md`).

**Agent workflow — `docs/agents/`**:
- `docs/agents/engineering-workflow.md` ← seed [`engineering-workflow.md`](./engineering-workflow.md). Adapt the tracker commands, verification commands and delivery policy to the repo; preserve the docs-first gate, Wayfinder/grilling split, plan gate, ticket frontier, one-ticket-per-session implementation and evidence-based closure.

If a folder exists but its README/template is missing, create only what's missing. Never clobber a user's file — suggest the additions instead.

### 4. Run Matt Pocock's agent setup

For the operational part (where issues live, workflow/triage label vocabulary, domain layout), **invoke `/setup-matt-pocock-skills`** — it creates the tracker-facing files under `docs/agents/` and verifies the required tracker labels. Don't reimplement that part here. If the skill is unavailable, say so and proceed without it.

> Order: both skills edit the shared project instructions idempotently. Run Matt's setup, write/update `AGENTS.md`, then ensure the Claude bridge from step 5. Never duplicate the shared blocks in both files.

### 5. Write shared instructions for Codex and Claude

Use **`AGENTS.md` as the canonical shared project instructions**. Codex reads it natively. Claude Code reads `CLAUDE.md`, so ensure a root `CLAUDE.md` whose first active line is `@AGENTS.md`; keep only genuinely Claude-specific additions below that import.

- If only `AGENTS.md` exists: update it and create the minimal `CLAUDE.md` bridge.
- If only `CLAUDE.md` exists: preserve its content, create `AGENTS.md` for the shared blocks, add `@AGENTS.md` to `CLAUDE.md`, and remove only duplicated shared blocks after confirming the import covers them.
- If both exist: update `AGENTS.md`; ensure `CLAUDE.md` imports it; do not maintain two independent copies.
- Never replace unrelated user instructions. A symlink `CLAUDE.md -> AGENTS.md` is acceptable only when there are no Claude-specific additions; prefer the portable `@AGENTS.md` import.

`AGENTS.md` must **explain** the knowledge base — why each artifact matters and how it works (when to read, when to write, which skill maintains it) — not just list it. An agent that has never seen the repo should understand the role of `docs/` just by reading the shared instructions. Insert/update the four blocks from [`claude-md-blocks.md`](./claude-md-blocks.md), **adapting the repo's real paths**:

1. **Structure** — short list (apps/packages + the docs artifacts with a one-liner).
2. **The `docs/` folder — why it matters and how it works** — the main block: one subsection per artifact (`CONTEXT.md`/`docs/adr`/`system`/`plans`/`pendencias`/`aprendizados`) with *what it is · why it matters · how it works*. **Don't cut this block** — it's the heart.
3. **The routine** — what to read before the first planning question or before coding (incl. target + complementary `docs/system` feature-docs, `CONTEXT.md` and ADRs) and what to run when done (`/sync-doc`, `/to-plan done`, `/to-pending`, lesson).
4. **Skill ecosystem** — how `/setup-pedro-mota`, `/setup-matt-pocock-skills`, `/grill-with-docs`, `/wayfinder`, `/to-plan`, `/to-tickets`, `/implement`, `/to-pending` and `/sync-doc` fit into the GitHub issue-driven loop.

**Idempotency:** if a block already exists (even worded differently), update it in-place instead of duplicating. Preserve what the user wrote around it.

### 6. Done

Tell the user, in ≤6 lines: which artifacts were created/ensured, that `AGENTS.md` is canonical and `CLAUDE.md` imports it, and the work loop now in effect: **`/grill-with-docs` (or `/wayfinder` for large/foggy work) → `/to-plan` → `/to-tickets` → `/implement` → `/sync-doc` → `/to-plan done`** (+ `/to-pending` for what you deferred, + a lesson if you got bitten). Remind them they can edit the `README.md`/`_template.md`/seeds directly afterward.

## Related skills (the ecosystem)

This skill **installs the knowledge base**; the others **consume and maintain it**:

- **`/setup-matt-pocock-skills`** — agent config (issue tracker, triage, domain) in `docs/agents/`. Called in step 4.
- **`/grill-with-docs`** — after grounding in target + complementary `docs/system` docs, grills work that fits one planning session; creates one timestamped file for that standalone session in `docs/grills/`, fixes vocabulary in `CONTEXT.md`, and creates **ADRs** inline as decisions close.
- **`/wayfinder`** — after the same grounding, charts research, prototype and grilling tickets for work too large or foggy for one session. Its map, tickets and resolution comments on the tracker are the session trail; it does not create `docs/grills/` files.
- **`/to-plan`** — writes plans in `docs/plans/` (referencing relevant ADRs) and archives them in `done/` when implemented.
- **`/to-tickets`** — turns an approved plan into tracer-bullet GitHub Issues with explicit blocking edges and plan/doc pointers.
- **`/implement`** — implements one unblocked issue per fresh session, using TDD at agreed seams and code review before commit/closure.
- **`/to-pending`** — records loose ends in `docs/pending/` (detailed) and resolves/promotes them.
- **`/sync-doc`** — keeps `docs/system/` in sync with the code (+ "Topic map") at the end of each feature.

Keep them coherent: if you change the structure here, adjust the references in those skills.
