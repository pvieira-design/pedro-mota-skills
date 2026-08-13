---
name: setup-pedro-mota
description: COMPLETE bootstrap of a repo's durable knowledge base in Pedro Mota's standard. Creates or ensures CONTEXT.md, docs/adr/, docs/system/, docs/learnings/ and docs/agents/; configures tracker-backed grills, GitHub specs, tickets and deferred work; and keeps shared instructions in AGENTS.md with a CLAUDE.md bridge. Run once per repo or whenever this structure is missing.
disable-model-invocation: true
---

# Setup Pedro Mota

Bootstrap the **durable knowledge base** that makes an agent or person productive from day one: understand a feature by reading a page instead of scanning the code, preserve decisions already made, and avoid repeating mistakes already paid for. Each artifact answers a different question:

- **`CONTEXT.md`** — *what the words mean* (domain glossary).
- **`docs/adr/`** — *why we decided it this way* (Architecture Decision Records).
- **`docs/system/`** — *what the code does TODAY* (living technical docs; one feature per file). Maintained by `/sync-doc`.
- **GitHub Issues labelled `pending`** — *what's left open* (loose ends to revisit, outside the execution frontier). Created by `/to-pending`.
- **`docs/learnings/`** — *where we already erred* (lessons not to repeat).
- **GitHub Issues labelled `grill:session`** — *how we reasoned in standalone grillings* (live checkpoint in the body; chronological substantive rounds in comments).
- **`docs/agents/`** — operational agent config (issue tracker, workflow/triage labels, domain layout and the full engineering workflow), via `/setup-matt-pocock-skills` plus this skill.

Approved future work lives in GitHub: `/to-spec` publishes the implementation contract and `/to-tickets` creates its executable tracer-bullet queue. Treat existing `docs/plans/`, `docs/grills/` and `docs/pending/` trees as historical archives; never create or extend them.

This is a **prompt-driven** skill, not a script. Explore → present what you found → confirm with the user → write. Be **idempotent**: only create what's missing, never overwrite the user's work, update blocks in-place.

The current session chat and internal Orca messages are approved channels for sensitive values needed by setup. GitHub, generated repository files, commits, publishable patches and public logs are external: write only non-sensitive configuration consequences or safe references, never secrets, credentials, PII or raw sensitive payloads.

Install one hard grounding rule: **before the first question in `/grill-with-docs` or `/wayfinder`**, read `docs/system/README.md`, the target feature-doc and the adjacent/complementary feature-docs named by its topic map, then relevant `CONTEXT.md`/ADRs. Summarize established facts and ask the user only for decisions the knowledge base and code cannot answer.

> Folder/path names (`docs/system`, `docs/learnings`, `docs/adr`, `CONTEXT.md`) and the GitHub labels `grill:session` and `pending` are Pedro's established conventions. Existing `docs/plans/`, `docs/grills/` and `docs/pending/` trees are historical archives; do not add files or indexes there.

## Process

### 1. Explore

Understand the repo's current state (run in parallel):

- `ls docs/ docs/system/ docs/learnings/ docs/adr/ docs/agents/ 2>/dev/null` — what already exists?
- `ls -d docs/plans docs/grills docs/pending 2>/dev/null` — which historical archives already exist? Do not create them.
- `gh issue list --state open --label pending --limit 20` — which loose ends are deferred in GitHub?
- `ls CLAUDE.md AGENTS.md CONTEXT.md CONTEXT-MAP.md 2>/dev/null` — which root artifacts exist?
- `git remote -v` — which GitHub repository feeds Matt's issue-tracker setup?
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

**Lessons — `docs/learnings/`**:
- `docs/learnings/_template.md` ← seed [`learnings-template.md`](./learnings-template.md).
- `docs/learnings/README.md` ← seed [`learnings-readme.md`](./learnings-readme.md).

**Agent workflow — `docs/agents/`**:
- `docs/agents/engineering-workflow.md` ← seed [`engineering-workflow.md`](./engineering-workflow.md). Adapt tracker commands, verification commands and delivery policy; preserve the docs-first gate, Wayfinder/grilling split, spec gate, ticket frontier, one-ticket-per-session implementation and evidence-based closure.

If a folder exists but its README/template is missing, create only what's missing. Never clobber a user's file — suggest the additions instead.

### 4. Run Matt Pocock's agent setup

For the operational part (where issues live, workflow/triage label vocabulary, domain layout), **invoke `/setup-matt-pocock-skills`** — it creates the tracker-facing files under `docs/agents/` and verifies the required tracker labels. Don't reimplement that part here. If the skill is unavailable, say so and proceed without it.

For a GitHub tracker, also ensure `grill:session` and `pending` exist with their documented meanings. Create only missing labels; preserve compatible existing labels and stop on semantic conflict. These checks are owned here because the upstream Matt setup does not know Pedro's live-grill and deferred-work lifecycle.

> Order: both skills edit the shared project instructions idempotently. Run Matt's setup, write/update `AGENTS.md`, then ensure the Claude bridge from step 5. Never duplicate the shared blocks in both files.

### 5. Write shared instructions for Codex and Claude

Use **`AGENTS.md` as the canonical shared project instructions**. Codex reads it natively. Claude Code reads `CLAUDE.md`, so ensure a root `CLAUDE.md` whose first active line is `@AGENTS.md`; keep only genuinely Claude-specific additions below that import.

- If only `AGENTS.md` exists: update it and create the minimal `CLAUDE.md` bridge.
- If only `CLAUDE.md` exists: preserve its content, create `AGENTS.md` for the shared blocks, add `@AGENTS.md` to `CLAUDE.md`, and remove only duplicated shared blocks after confirming the import covers them.
- If both exist: update `AGENTS.md`; ensure `CLAUDE.md` imports it; do not maintain two independent copies.
- Never replace unrelated user instructions. A symlink `CLAUDE.md -> AGENTS.md` is acceptable only when there are no Claude-specific additions; prefer the portable `@AGENTS.md` import.

`AGENTS.md` must **explain** the knowledge base — why each artifact matters and how it works (when to read, when to write, which skill maintains it) — not just list it. An agent that has never seen the repo should understand the role of `docs/` just by reading the shared instructions. Insert/update the four blocks from [`claude-md-blocks.md`](./claude-md-blocks.md), **adapting the repo's real paths**:

1. **Structure** — short list (apps/packages + the docs artifacts with a one-liner).
2. **The knowledge base — why it matters and how it works** — the main block: one subsection per durable artifact (`CONTEXT.md`, `docs/adr`, `docs/system`, `docs/learnings`) plus GitHub grills, specs, tickets and `pending` issues. **Don't cut this block** — it's the heart.
3. **The routine** — what to read before the first planning question or coding, and what to run when done (`/sync-doc`, `/to-pending`, lesson).
4. **Skill ecosystem** — how `/setup-pedro-mota`, `/setup-matt-pocock-skills`, `/grill-with-docs`, `/wayfinder`, `/to-spec`, `/to-tickets`, `/implement`, `/to-pending` and `/sync-doc` fit into the GitHub issue-driven loop.

**Idempotency:** if a block already exists (even worded differently), update it in-place instead of duplicating. Preserve what the user wrote around it.

### 6. Done

Tell the user, in ≤6 lines: which artifacts were created or ensured, that `AGENTS.md` is canonical and `CLAUDE.md` imports it, and the work loop now in effect: **`/grill-with-docs` (or `/wayfinder` for large/foggy work) → `/to-spec` → `/to-tickets` → `/implement` → `/sync-doc`** (+ `/to-pending` for deferrals, + a lesson after a recurring trap). State that existing `docs/plans/`, `docs/grills/` and `docs/pending/` remain historical only.

## Related skills (the ecosystem)

This skill **installs the knowledge base**; the others **consume and maintain it**:

- **`/setup-matt-pocock-skills`** — agent config (issue tracker, triage, domain) in `docs/agents/`. Called in step 4.
- **`/grill-with-docs`** — after grounding, creates a `grill:session` + `ready-for-human` issue before its first substantive question. The body is the live checkpoint; comments preserve each substantive round against compaction.
- **`/wayfinder`** — after the same grounding, charts research, prototype and grilling tickets for work too large or foggy for one session. Its map, tickets and resolution comments are the session trail.
- **`/to-spec`** — reads the complete source issue history and publishes the closed implementation contract as a GitHub issue, grounded in vocabulary, ADRs and `docs/system/`.
- **`/to-tickets`** — turns the approved spec into tracer-bullet GitHub Issues with explicit blocking edges and spec/doc pointers.
- **`/implement`** — implements one unblocked issue per fresh session, using TDD at agreed seams and code review before commit/closure.
- **`/to-pending`** — records loose ends as GitHub issues labelled `pending` and resolves/promotes them.
- **`/sync-doc`** — keeps `docs/system/` in sync with the code (+ "Topic map") at the end of each feature.

Keep them coherent: if you change the structure here, adjust the references in those skills.
