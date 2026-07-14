These are the shared blocks the skill inserts/updates in the repo's canonical `AGENTS.md`. Claude Code should receive them through a root `CLAUDE.md` whose first active line is `@AGENTS.md`; do not duplicate the blocks in both files. Adapt the real paths (language, monorepo vs single app) to the project and update existing blocks in place.

The goal of the shared project instructions is that an agent who has **never seen the repo** understands, just by reading: (1) which docs folders exist, (2) **why each one matters**, (3) **how each one works** (when to read, when to write, which skill maintains it) and (4) the work loop. Listing isn't enough — it has to explain.

> Folder/path names (`docs/system`, `docs/plans`, `docs/pending`, `docs/learnings`, `docs/grills`, `docs/adr`, `CONTEXT.md`) are Pedro's established conventions — keep them as-is. Adapt the prose to the target repo's language.

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
- `docs/grills/` — **standalone grilling-session memory** (one timestamped file per explicit `/grill-with-docs` session; no README; not used by Wayfinder)
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
- **How it works:** create with `/to-plan` (which runs a completeness gate so nothing decided stays implicit); publish with `/to-tickets` as GitHub Issues; execute one unblocked issue per fresh `/implement` session, verifying every acceptance criterion before closure; close with `/to-plan done <slug>` (goes to `docs/plans/done/`).

### `docs/pending/` — what's left open (don't forget)

- **What it is:** loose ends deferred mid-work — edge case out of scope, postponed decision, TODO, tech debt, open question. One per file.
- **Why it matters:** "we'll look at it later" vanishes if it lives only in your head. It's the in-repo backlog of what can't be forgotten.
- **How it works:** record with `/to-pending` when you defer something (detailed: the what + why + impact + next step). Resolved → `done/`. Can graduate to a plan (`/to-plan`) or an issue.

### `docs/learnings/` — where we already erred (don't repeat)

- **What it is:** lessons from bugs with non-obvious causes, tool/environment traps.
- **Why it matters:** avoids paying the same mistake twice — the most expensive part of rework.
- **How it works:** **read** before touching a sensitive area; **write** when bitten by something that cost time + tends to recur + has an actionable rule.

### `docs/grills/` — how we reasoned in standalone grillings (auxiliary session memory)

- **What it is:** the auxiliary memory of an explicit, standalone `/grill-with-docs` session — one timestamped file containing the Q&A trail, dropped hypotheses and open points. It is not the canonical feature doc.
- **Why it matters:** a standalone grilling has no tracker ticket of its own, so the live reasoning needs a temporary in-repo home until its durable outcomes crystallise.
- **How it works:** `/grill-with-docs` creates `YYYY-MM-DD-HHmm-<detailed-slug>.md` at the start and updates it inline. Durable results flow to `CONTEXT.md`, ADRs and a plan; `docs/system/` changes only after the code changes. Wayfinder never creates a grill file: its map, tickets and resolution comments on the tracker already provide the trail. Casual design conversations do not create grills automatically.
```

---

## BLOCK 3 — the routine (before planning questions, coding, and after coding)

```markdown
## 🧭 Before asking planning questions or touching the code (mandatory)

1. Open **`docs/system/README.md`** → "Topic map" → read the target `feature-*.md` **and the adjacent/complementary feature-docs** that interact with the work.
2. Consult **`CONTEXT.md`** (vocabulary) and the ADRs cited by those feature-docs. If starting a standalone grill that reopens an earlier topic, read the related **`docs/grills/`** file too.
3. Check **`docs/learnings/`** if the area is sensitive, plus existing **`docs/plans/`** and **`docs/pending/`** entries for the subject.
4. Summarize established facts, existing seams and genuine unknowns. Ask the user only for product/design decisions that the docs and code cannot answer.
5. This is a **hard gate before the first question** in `/grill-with-docs` or `/wayfinder`, and before their first tracker mutation. Only then inspect the specific code paths the docs identify.

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
- **`/grill-with-docs`** — first grounds itself in target + complementary `docs/system` docs, then grills work that fits one planning session; records that standalone session in `docs/grills/`, updates `CONTEXT.md` and creates ADRs inline as decisions close.
- **`/wayfinder`** — performs the same docs-first grounding, then maps research, prototype and grilling tickets until the destination can be specified precisely. The tracker map/tickets/comments are its trail; it does not create a local grill.
- **`/to-plan`** — distills the grilling into a plan in `docs/plans/`; `/to-plan done` archives the finished one.
- **`/to-tickets`** — publishes the approved plan as tracer-bullet GitHub Issues with explicit blocking edges and pointers back to the plan/docs.
- **`/implement`** — claims and implements one unblocked GitHub Issue per fresh session, then runs TDD/review/verification before committing and closing it.
- **`/to-pending`** — records a loose end in `docs/pending/` (detailed); `/to-pending done` resolves it.
- **`/sync-doc`** — syncs `docs/system/` with the real code at the end of implementation.

Loop: **grill (or `/wayfinder`) → `/to-plan` → `/to-tickets` → `/implement` one issue per fresh session → `/sync-doc` → `/to-plan done`** (+ `/to-pending` for what you deferred, + `docs/learnings/` if there was a trap). `/handoff` remains the direct-session alternative when a GitHub ticket queue is unnecessary.
```
