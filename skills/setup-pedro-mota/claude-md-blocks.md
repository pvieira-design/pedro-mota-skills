These are the shared blocks the skill inserts/updates in the repo's canonical `AGENTS.md`. Claude Code should receive them through a root `CLAUDE.md` whose first active line is `@AGENTS.md`; do not duplicate the blocks in both files. Adapt the real paths (language, monorepo vs single app) to the project and update existing blocks in place.

The goal of the shared project instructions is that an agent who has **never seen the repo** understands, just by reading: (1) which docs folders exist, (2) **why each one matters**, (3) **how each one works** (when to read, when to write, which skill maintains it) and (4) the work loop. Listing isn't enough — it has to explain.

> Folder/path names (`docs/system`, `docs/learnings`, `docs/adr`, `CONTEXT.md`) and the GitHub labels `grill:session` and `pending` are Pedro's established conventions. Treat existing `docs/plans/`, `docs/grills/` and `docs/pending/` as historical archives. Adapt the prose to the target repo's language.

---

## BLOCK 1 — add/ensure in the "Structure" section

```markdown
## Structure

- `<app(s)/...>` — <role of each app/package in the repo>
- `CONTEXT.md` — **glossary** of the domain (canonical vocabulary)
- `docs/adr/` — **decisions** of architecture and their whys
- `docs/system/` — **living technical docs** (what the code does TODAY)
- GitHub Issues labelled `spec` — **approved future work**
- GitHub Issues labelled `grill:session` — **live standalone grilling history**
- GitHub Issues labelled `pending` — **loose ends** to revisit (outside the execution frontier)
- `docs/learnings/` — **lessons** from mistakes already made
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

### GitHub `spec` issues — what we're GOING to do (future)

- **What it is:** the approved implementation contract published from closed decisions, with behavior, implementation/testing decisions, scope and acceptance expectations.
- **Why it matters:** separates future intent from `docs/system/`, which describes only the present, while keeping the executable queue shareable.
- **How it works:** publish with `/to-spec`; decompose with `/to-tickets` into blocked tracer-bullet issues; execute one frontier issue per fresh `/implement` session. Existing `docs/plans/` is historical only.

### GitHub `grill:session` issues — how we close decisions without losing context

- **What it is:** the live history of an explicit standalone `/grill-with-docs` session. Create `[Grill] <specific topic>` with `grill:session` + `ready-for-human` after grounding and before the first substantive question.
- **Why it matters:** chat can compact or move to a clean session. The tracker must be sufficient to recover the reasoning without chat memory.
- **How it works:** keep the current checkpoint in the body (objective, sources, facts, scope, non-goals, decisions, open questions, discarded hypotheses and next checkpoint). After every substantive answer, add a chronological comment with findings, answer and resulting decision, then update the body before asking again. When decisions close, `/to-spec` reads the body, every comment and linked artifact; after publishing the spec, comment its link and close the grill.

### GitHub `pending` issues — what's left open (don't forget)

- **What it is:** loose ends deferred mid-work — edge case out of scope, postponed decision, TODO, tech debt, open question. One GitHub issue per item, labelled `pending`.
- **Why it matters:** "we'll look at it later" vanishes if it lives only in your head. The label keeps it visible without making it executable.
- **How it works:** record with `/to-pending` when you defer something (what + why + impact + next step). `resume` removes `pending` and sends it to triage; `done` closes it. Existing `docs/pending/` content is historical only.

### `docs/learnings/` — where we already erred (don't repeat)

- **What it is:** lessons from bugs with non-obvious causes, tool/environment traps.
- **Why it matters:** avoids paying the same mistake twice — the most expensive part of rework.
- **How it works:** **read** before touching a sensitive area; **write** when bitten by something that cost time + tends to recur + has an actionable rule.

Existing `docs/grills/` content is historical only; do not create or update files there.
```

---

## BLOCK 3 — the routine (before planning questions, coding, and after coding)

```markdown
## 🧭 Before asking planning questions or touching the code (mandatory)

The current session chat and internal Orca messages are approved channels for sensitive values needed by the task. GitHub, versioned files, commits, publishable patches and public logs are external: write only non-sensitive consequences or safe references there, never secrets, credentials, PII or raw sensitive payloads. Do not block or invent an indirect handoff merely because a necessary value moves between the two approved channels.

1. Open **`docs/system/README.md`** → "Topic map" → read the target `feature-*.md` **and the adjacent/complementary feature-docs** that interact with the work.
2. Consult **`CONTEXT.md`** (vocabulary) and the ADRs cited by those feature-docs.
3. Check **`docs/learnings/`** if the area is sensitive, plus related GitHub grill/map/spec/ticket issues and open issues labelled **`pending`**. Read historical `docs/grills/` only when an old reference points there.
4. Summarize established facts, existing seams and genuine unknowns. Ask the user only for product/design decisions that the docs and code cannot answer.
5. This is a **hard gate before the first question** in `/grill-with-docs` or `/wayfinder`, and before their first tracker mutation. Only then inspect the specific code paths the docs identify.

## ⚠️ When done (mandatory)

1. **`/sync-doc`** — update the affected `docs/system/feature-*.md` (the living doc must never diverge from the code).
2. **Tracker proof** — update/close the implementation issue only after its criteria and verification evidence are recorded.
3. **`/to-pending`** — if you deferred something ("we'll look later"), record it as a GitHub issue labelled `pending` so it's not forgotten.
4. **`docs/learnings/`** — record the lesson if you got bitten by a non-obvious trap.
```

---

## BLOCK 4 — the skill ecosystem

```markdown
## Documentation skills (how they fit together)

- **`/setup-pedro-mota`** — bootstrap: creates the durable knowledge base (`CONTEXT.md`, `docs/adr/`, `docs/system/`, `docs/learnings/`, agent config), verifies GitHub workflow labels and adds this documentation to AGENTS.md. Once per repo.
- **`/setup-matt-pocock-skills`** — agent config (issue tracker, triage labels, domain layout) in `docs/agents/`. Called by `/setup-pedro-mota`.
- **`/grill-with-docs`** — first grounds itself, then creates and maintains a `grill:session` + `ready-for-human` issue as a compaction-safe checkpoint while closing one decision at a time.
- **`/wayfinder`** — performs the same docs-first grounding, then maps research, prototype and grilling tickets until the destination can be specified precisely. The tracker map/tickets/comments are its trail; it does not create a local grill.
- **`/to-spec`** — reads the complete grill/map issue history and distills closed decisions into an approved GitHub implementation contract.
- **`/to-tickets`** — publishes tracer-bullet GitHub Issues with explicit blocking edges and pointers back to the spec and durable docs.
- **`/implement`** — claims and implements one unblocked GitHub Issue per fresh session, then runs TDD/review/verification before committing and closing it.
- **`/to-pending`** — records a loose end as a GitHub issue labelled `pending`; `resume` sends it to triage and `done` resolves it.
- **`/sync-doc`** — syncs `docs/system/` with the real code at the end of implementation.

Loop: **grill (or `/wayfinder`) → `/to-spec` → `/to-tickets` → `/implement` one issue per fresh session → `/sync-doc` → tracker proof/closure** (+ `/to-pending` for what you deferred, + `docs/learnings/` if there was a trap). `/handoff` remains the direct-session alternative when a GitHub ticket queue is unnecessary.
```
