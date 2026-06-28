These are the blocks the skill inserts/updates in the repo's `CLAUDE.md` (or `AGENTS.md`). Adapt the real paths (language, monorepo vs single app) to the project. Don't duplicate blocks that already exist — update them in-place.

The goal of CLAUDE.md here is that an agent who has **never seen the repo** understands, just by reading: (1) which docs folders exist, (2) **why each one matters**, (3) **how each one works** (when to read, when to write, which skill maintains it) and (4) the work loop. Listing isn't enough — it has to explain.

> Folder/path names (`docs/system`, `docs/plans`, `docs/pending`, `docs/learnings`, `docs/grills`, `docs/adr`, `CONTEXT.md`) are Pedro's established conventions — keep them as-is. If the target repo writes its CLAUDE.md in another language, adapt the prose to that language.

---

## BLOCK 1 — add/ensure in the "Structure" section

```markdown
## Structure

- `<app(s)/...>` — <role of each app/package in the repo>
- `CONTEXT.md` — **glossary** of the domain (canonical vocabulary)
- `docs/adr/` — **decisions** of architecture and their whys
- `docs/system/` — **living technical docs** (what the code does TODAY)
- `docs/plans/` — **work plans** (what we're going to do; becomes `done/`)
- `docs/pending/` — **loose ends** to revisit (don't forget)
- `docs/learnings/` — **lessons** from mistakes already made
- `docs/grills/` — **grilling-session memory** (how we reasoned to each decision)
```

---

## BLOCK 2 — the `docs/` folder (why it matters and how it works) — THIS is the heart

```markdown
## 📚 The `docs/` folder — why it matters and how it works

`docs/` is the **system's memory** — the knowledge base that makes the agent smart from day one: it understands a feature by reading a page instead of scanning the code, doesn't reopen decisions already made, and doesn't repeat mistakes already paid for. Keeping `docs/` current is **not bureaucracy** — it's what makes every next task cheaper. Each artifact answers a different question:

### `CONTEXT.md` — what the words mean (vocabulary)

- **What it is:** the domain **glossary** — the canonical term for each concept (and the synonyms to avoid). Glossary only: not a spec, not implementation docs.
- **Why it matters:** aligns the language across code, docs and people; avoids the chaos of "customer" vs "account" vs "user" meaning different things.
- **How it works:** consulted anytime; pinned/updated during grilling (`/grill-with-docs`). Short, opinionated definitions.

### `docs/adr/` — why we decided this way (decisions)

- **What it is:** Architecture Decision Records — one hard-to-reverse decision per numbered file, with the *why*.
- **Why it matters:** the code shows the *how*, not the *why*. Without an ADR, the rejected alternative gets suggested again in 6 months.
- **How it works:** **read** before touching a structural decision; **write** an ADR when the decision is hard to reverse + surprising + a real trade-off (often during a `/grill-with-docs`).

### `docs/system/` — what the code does TODAY (present)

- **What it is:** **living** technical docs, one feature per file (`feature-*.md`). **The source of truth for the code.**
- **Why it matters:** first place to read before coding; in a few KB you know where to touch and what not to break.
- **How it works:** **read FIRST** (via `docs/system/README.md` → "Topic map"); **update AFTER** with `/sync-doc`. If it diverges from the code, the doc is wrong — fix it.

### `docs/plans/` — what we're GOING to do (future)

- **What it is:** execution plans, ephemeral, carrying the closed decisions from a grilling **and a Definition of Done** — an atomic, verifiable acceptance checklist that is the plan's completeness contract.
- **Why it matters:** separates intent from reality; whoever implements doesn't reopen everything — and the Definition of Done is what stops planned work from being silently left out (execution verifies every item, not just a green test suite).
- **How it works:** create with `/to-plan` (which runs a completeness gate so nothing decided stays implicit); execute with `/do-task` / `/night-shift` (which tick every acceptance criterion with proof before marking done); close with `/to-plan done <slug>` (goes to `docs/plans/done/`).

### `docs/pending/` — what's left open (don't forget)

- **What it is:** loose ends deferred mid-work — edge case out of scope, postponed decision, TODO, tech debt, open question. One per file.
- **Why it matters:** "we'll look at it later" vanishes if it lives only in your head. It's the in-repo backlog of what can't be forgotten.
- **How it works:** record with `/to-pending` when you defer something (detailed: the what + why + impact + next step). Resolved → `done/`. Can graduate to a plan (`/to-plan`) or an issue.

### `docs/learnings/` — where we already erred (don't repeat)

- **What it is:** lessons from bugs with non-obvious causes, tool/environment traps.
- **Why it matters:** avoids paying the same mistake twice — the most expensive part of rework.
- **How it works:** **read** before touching a sensitive area; **write** when bitten by something that cost time + tends to recur + has an actionable rule.

### `docs/grills/` — how we reasoned to the decision (grilling memory)

- **What it is:** the **memory of each grilling session** — one file per topic, accumulating the closed decisions, the Q&A trail (questions + the answers given), the dropped hypotheses, and what's still open. Upstream of `CONTEXT.md`/ADR/plan: what crystallises here flows out to those, with a pointer back.
- **Why it matters:** a grilling produces a lot of reasoning that doesn't fit in a glossary term, one ADR, or a plan. Without this, the *why behind the why* — and the rejected options — evaporate when the session ends, and the same ground gets re-litigated next time.
- **How it works:** maintained by `/grill-with-docs` — at the start of a grill it **finds the topic's file or creates it** (keyed by topic, one per subject), then appends a **dated session entry** and captures decisions + trail **inline** as the session unfolds. **Read** it before re-opening a topic that was already grilled.
```

---

## BLOCK 3 — the routine (before and after coding)

```markdown
## 🧭 Before touching the code (mandatory)

1. Open **`docs/system/README.md`** → "Topic map" → read the area's `feature-*.md`.
2. Consult **`CONTEXT.md`** (vocabulary) and **`docs/adr/`** (why the area is the way it is) when relevant; if you're about to re-open a topic that was grilled before, read its **`docs/grills/`** file first (the reasoning trail).
3. Check **`docs/learnings/`** if the area is sensitive.
4. See if there's already a plan in **`docs/plans/`** or open items in **`docs/pending/`** about what you're going to do.
5. Only then open the code.

## ⚠️ When done (mandatory)

1. **`/sync-doc`** — update the affected `docs/system/feature-*.md` (the living doc must never diverge from the code).
2. **`/to-plan done <slug>`** — if you implemented a plan from `docs/plans/`, archive it in `done/`.
3. **`/to-pending`** — if you deferred something ("we'll look later"), record it in `docs/pending/` so it's not forgotten.
4. **`docs/learnings/`** — record the lesson if you got bitten by a non-obvious trap.
```

---

## BLOCK 4 — the skill ecosystem

```markdown
## Documentation skills (how they fit together)

- **`/setup-pedro-mota`** — bootstrap: creates the whole knowledge base (`CONTEXT.md`, `docs/adr/`, `docs/system/`, `docs/plans/`, `docs/pending/`, `docs/learnings/`, agent config) + this documentation in CLAUDE.md. Once per repo.
- **`/setup-matt-pocock-skills`** — agent config (issue tracker, triage labels, domain layout) in `docs/agents/`. Called by `/setup-pedro-mota`.
- **`/grill-with-docs`** / **`/grill-me`** — grilling that stress-tests the plan; records the session in `docs/grills/` (one file per topic, find-or-create), updates `CONTEXT.md` (vocabulary) and creates ADRs **inline** as decisions close.
- **`/to-plan`** — distills the grilling into a plan in `docs/plans/`; `/to-plan done` archives the finished one.
- **`/to-pending`** — records a loose end in `docs/pending/` (detailed); `/to-pending done` resolves it.
- **`/sync-doc`** — syncs `docs/system/` with the real code at the end of implementation.

Loop: **grill (`CONTEXT.md`+ADR) → `/to-plan` → implement → `/sync-doc` → `/to-plan done`** (+ `/to-pending` for what you deferred, + `docs/learnings/` if there was a trap).

### If your workspace uses the Click Notes MCP (optional)

A board-driven way to execute plans, plus skills for the company's meetings + knowledge graph. These need the Click Notes MCP connected — skip this section if you don't use it.

- **`/to-tasks`** — publish a `docs/plans/` plan as Click Notes tasks + subtasks, **gated in the title** (`[READY FOR DEV]` to code · `[PLANNING]` to leave alone · `[WIP]` while worked). The plan = one root task, each vertical slice = a subtask carrying pointers to the plan + ADRs.
- **`/do-task`** — an agent grabs the next `[READY FOR DEV]` task, reads its linked plan + ADRs + `feature-*.md`, implements, tests, and marks it done (supervised, one at a time). Never codes a `[PLANNING]` task; refuses to code with no detailed plan.
- **`/night-shift`** — runs `/do-task` in a loop **unattended** (e.g. overnight): grounds each task in the project's `docs/system/` + ADRs, commits green work to main, tries hard to resolve failures before parking, and posts a morning report. The board's per-task **Verify** block + context anchor are what make this reliable.
- **`/clicknotes-meeting`** — rewrite a meeting's notes from its transcript + generate its tasks (deduped against existing ones).
- **`/clicknotes-memory`** / **`/clicknotes-recall`** — create/update and search the company knowledge graph (Memória).
- **`/clicknotes-tasks`** — reconcile the task board against what's actually been done.

Board-driven branch: **`/to-plan` → `/to-tasks` → `/do-task` (or `/night-shift` unattended) → `/sync-doc` → `/to-plan done`**. `/handoff` and `/to-tasks` are two ways to pass a written plan to a fresh agent — a ready-to-paste prompt vs. a board agents pull from.
```
