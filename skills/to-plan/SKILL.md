---
name: to-plan
description: Turn confirmed decisions from a standalone grilling session or completed Wayfinder map into an executable implementation plan under docs/plans/. Also close a finished plan by moving it to docs/plans/done/ with a ✅ badge.
---

This skill has **two modes**. Decide which by the argument:

- Argument starts with `done` (or `complete`/`finish`) → **CLOSE mode**.
- Anything else (including no argument, right after a grilling session) → **BUILD mode**.

Before anything, find today's date with `date +%F` and the repo's plans folder (`docs/plans/` by default — confirm it exists; if the repo uses another documented path, use the repo's).

---

## BUILD mode — write the plan

The decisions were closed either in a standalone `grill-with-docs` session or through a completed Wayfinder map. The goal is to **distill the canonical decisions** into an executable plan that a clean autonomous session can implement without reopening them.

> ### Re-ground before you plan this topic — don't trust a long chat
> When you've been planning for a while and **move from one topic to another**, the chat context is bloated and you *will* drift. Before planning a new subject, **refresh on it from the source of truth, not from memory**:
> - the **current code** in that area (read it now — don't rely on what you "remember" from earlier in the session);
> - the repo's docs about it — `docs/grills/` for standalone grilling, or the Wayfinder map/tickets/resolution comments for a mapped effort; plus `docs/plans/` (open **and** `done/`), `docs/system/feature-*.md`, `docs/adr/`, `docs/pending/`, `docs/learnings/`, and `CONTEXT.md`.
>
> Get current on what exists *today*, **then** distill the decisions below. This is re-grounding, not re-litigating — don't reopen decisions already closed, just make sure the plan is anchored to reality and not to a stale, overflowing chat.

### 1. Read the repo's convention first

If `docs/plans/README.md` exists, **read it and follow** its naming convention and section structure exactly — it's the source of truth for this repo's format. The instructions below are the fallback when there's no README.

### 2. File name

Default: `YYYY-MM-DD-short-title.md` (today's date + kebab-case slug of the title). E.g. `2026-06-13-installment-no-interest-discount.md`. If the user passed a title in the argument, derive the slug from it; otherwise propose one from the grilling topic and confirm in one line.

Save under `docs/plans/`.

### 3. Content

Synthesize from **this conversation** — don't re-explore the code from scratch or re-derive decisions already closed. Capture what was actually agreed. Structure (use the repo's README if it differs):

1. **Goal / context** — the problem in 2-3 lines.
2. **Closed decisions** — what's already been decided **and why**, so the agent doesn't reopen it. This is the most important section: everything the grilling resolved lives here.
3. **Current model** — how the relevant code works today, with **real paths**.
4. **Changes per file** — numbered, each with path + function/symbol + snippet or precise description of the change.
5. **Rules / invariants** — what must NOT break.
6. **Tests** — cases to cover (unit / e2e), the public **seams** agreed for TDD, prior art in the repo and the exact verification commands. An AFK executor must not need to invent where to test.
7. **Acceptance criteria — the Definition of Done** — a flat, numbered checklist (`- [ ]`) where **each item is one concrete, independently verifiable outcome**. This is the plan's completeness contract: execution is "done" only when every box is checked. Each item must map to a change in §4 and state *how* it's proven (a test, a command, an observable behavior). If you can't say how an item would be verified, it's too vague — sharpen it until you can.
8. **Out of scope** — what's explicitly left out.

Quality rules:
- **Don't duplicate** what's already in ADRs, `CONTEXT.md`, `docs/system/feature-*.md`, or issues — **reference by path/URL**.
- **Future** tense ("we'll record…", "create the function…") — it's intent, not current state (that's `docs/system/`'s job).
- Real file/function/table names, no placeholders.
- **No implicit work.** Everything the grilling decided must appear as a concrete item in §4 (Changes per file) **and** as an acceptance criterion in §7 — never only described in prose. If it isn't a checkable deliverable, it *will* be skipped at execution.
- **Concrete over open.** Prefer "add field `X` to table `Y` and surface it in endpoint `Z`" over "improve the data model". An item a stranger can't check done/not-done is a future gap — make it checkable.
- **Traceable both ways.** Every §4 change is covered by ≥1 acceptance criterion, and every criterion traces back to a §4 change. No orphans on either side.
- At the top of the file, leave a status header: `> 🚧 **Status: ready to implement** — created on YYYY-MM-DD.`

### 3.1 ADRs — plan and decision work together (important)

A plan and an ADR are different things that complement each other: the **plan** is ephemeral (the *how/what* we'll do; disappears into `done/`), the **ADR** is permanent (the *why* of a hard-to-reverse decision; lives forever in `docs/adr/`). A plan **references** ADRs; it never duplicates them.

Do both ends:

1. **Existing decisions → cite the ADR.** Before writing, read `docs/adr/` (and `docs/adr/README.md`). Every recorded decision that constrains this plan must be **cited by link** in "Closed decisions" / "Current model" (e.g. "identity by CPF — see [ADR 0001](../adr/0001-...md)"). That way the implementer inherits the why without you rewriting it.

2. **New ADR-worthy decision → offer to create the ADR.** If the grilling closed a decision that is **(a) hard to reverse + (b) surprising without context + (c) a real trade-off**, it can't live only in the plan (which will be archived). **Offer to create an ADR** in `docs/adr/` (sequential numbering, format from `docs/adr/_template.md` / `README.md`) and, in the plan, **link to it** instead of repeating the rationale. All three conditions must hold — if the decision is easy to reverse or obvious, it stays in the plan only.

In short: the "durable why" goes to the ADR (and the plan points to it); the "how to execute" stays in the plan.

### 3.2 Completeness gate — run before you save (this is what stops "stuff left out")

The #1 failure of a plan is being **too open**, so execution silently drops things and you have to send it back to "implement what was missing". Before saving, walk the plan against its sources and close every gap:

1. **Re-read the canonical decisions** — the standalone grill file, or the Wayfinder ticket resolution comments and map pointers. For **each** decided outcome, confirm it appears as a concrete change in §4 **and** as an acceptance criterion in §7. Anything that lives only in prose → promote it to a checkable deliverable, or it won't get built.
2. **Every criterion is verifiable** — each `- [ ]` says *how* it's proven (test, command, observable behavior). Rewrite the vague ones until a stranger could check them.
3. **Traceability holds both ways** — no §4 change without a covering criterion; no criterion without a §4 change.

Only save once the Definition of Done (§7) covers **everything** that was decided. State in one line that the gate passed (e.g. "Completeness gate: 9 criteria, all traced to changes and verifiable"). A plan that clears this gate is one an executor can finish without you reviewing what was left out.

### 4. Update the index

Add a line for the new plan in the "Plans" section of `docs/plans/README.md` (relative link + 1-sentence summary + status).

### 5. Close out

Tell the user the path of the created plan and offer the next step (e.g. `/handoff` to an executing agent, `/to-tickets` to publish it as GitHub implementation issues, or implement now). If the grilling produced terms for `CONTEXT.md`, or an ADR-worthy decision you haven't recorded yet (see 3.1), remind/offer to record it before moving on — that knowledge outlives the plan.

---

## CLOSE mode — mark a plan as done

Fires when the plan is already implemented. Argument: `done <file-or-slug>` (e.g. `done installment-discount` or `done 2026-06-13-installment-no-interest-discount.md`).

### 1. Locate the plan

Search `docs/plans/` for the file matching the argument (by slug/date). If ambiguous, list the candidates and ask. If no argument was passed, list the open plans (those in the root of `docs/plans/`, outside `done/`) and ask which to close.

### 2. Stamp the ✅ badge

In the file itself:
- Replace the top status header with: `> ✅ **Completed on YYYY-MM-DD.**` (today's date via `date +%F`).
- Prefix the H1 title with `✅ ` (e.g. `# ✅ Installment no-interest discount`).
- If the plan has an acceptance-criteria checklist, mark the items as `- [x]` (if actually met; don't invent).

### 3. Move to `done/`

- Create `docs/plans/done/` if it doesn't exist yet (lazy — only now).
- Move the file there with `git mv docs/plans/<file> docs/plans/done/<file>` (preserves history). Outside a git repo, use `mv`.

### 4. Update the index

In `docs/plans/README.md`, move that plan's line to reflect the new state: link pointing to `done/<file>` and status **✅ Completed (YYYY-MM-DD)**. If there's a "Completed" section, put it there; otherwise mark the status on the line itself.

### 5. Sync the technical doc (repo rule)

The `docs/plans/README.md` rule says: when finishing a plan, **the source of truth for the code becomes `docs/system/feature-*.md`**. Check whether the matching feature has up-to-date technical docs in `docs/system/`; if it diverged or doesn't exist, tell the user and offer to run `/sync-doc` (don't force it).

### 6. Close out

Confirm: file moved to `docs/plans/done/<file>`, badge applied, README updated. Point out pending items (e.g. technical doc to sync).

---

## Notes

- This skill **does not implement** the plan — it only writes it (BUILD mode) or archives it as done (CLOSE mode).
- Always `git add` explicitly the files you created/moved/edited (don't rely on `git add -A` — there may be other sessions in the same checkout). Don't commit unless the user asks.

## Related skills (the ecosystem)

`/to-plan` is the bridge between planning and implementing. The neighboring folders and skills:

- **`/setup-pedro-mota`** — installs the docs structure (`docs/system/`, `docs/plans/`, `docs/pending/`, `docs/learnings/`) and the convention this skill follows. If `docs/plans/` doesn't exist, suggest running it first.
- **`/grill-with-docs`** / **`/wayfinder`** — the decision work that **precedes** BUILD mode; closed decisions come from the standalone grill or the Wayfinder ticket resolutions.
- **`docs/adr/`** — the plan's **durable counterpart**: the plan is ephemeral (goes to `done/`), the ADR is permanent. Cite existing ADRs in the plan and promote every hard-to-reverse decision to an ADR (see step **3.1**). ADRs are **never** moved to `done/`.
- **`/to-tickets`** / **`/implement`** — the issue-driven way to execute this plan: `/to-tickets` publishes tracer-bullet slices as GitHub Issues with blocking edges, then a fresh autonomous session runs `/implement` for one unblocked issue at a time. Each issue points back to this plan + its ADRs and feature docs.
- **`/sync-doc`** — this skill's **counterpart on the time axis**: `docs/plans/` is the future (what we'll do), `docs/system/` is the present (what exists). In CLOSE mode, after moving the plan to `done/`, run `/sync-doc <feature>` so the technical doc reflects what shipped.
- **`/to-pending`** — what you left in "Out of scope" or deferred during execution must not vanish: record it as a pending item in `docs/pending/` (a loose end is lighter than a plan).
- **`docs/learnings/`** — if during the plan's implementation you got bitten by a non-obvious trap, record the lesson there (not in the plan or the system doc).

Typical loop: **grill (or `/wayfinder` for large/foggy work) → `/to-plan` → `/to-tickets` → `/implement` one issue per fresh session → `/sync-doc` → `/to-plan done`** (+ `/to-pending` for what's left open).
