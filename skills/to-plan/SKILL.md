---
name: to-plan
description: Turn the decisions from a grilling/design session into an implementation plan doc under docs/plans/, following the repo's own plan convention. Also closes out a finished plan by moving it to docs/plans/done/ with a ✅ badge. Use at the end of a grill-me / grill-with-docs session to capture the agreed plan ("build the plan", "write up the plan", "save the plan"), or to mark a plan as done.
argument-hint: "<plan title>  |  done <file-or-slug>"
---

This skill has **two modes**. Decide which by the argument:

- Argument starts with `done` (or `complete`/`finish`) → **CLOSE mode**.
- Anything else (including no argument, right after a grilling session) → **BUILD mode**.

Before anything, find today's date with `date +%F` and the repo's plans folder (`docs/plans/` by default — confirm it exists; if the repo uses another documented path, use the repo's).

---

## BUILD mode — write the plan

You just went through a grilling/design session (probably `grill-me` or `grill-with-docs`). The goal now is to **distill what was decided in this conversation** into an executable plan doc that another agent (or a future session) can pick up and implement without reopening the decisions.

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
6. **Tests** — cases to cover (unit / e2e), pointing to the relevant specs.
7. **Acceptance criteria** — verifiable checklist (`- [ ]`).
8. **Out of scope** — what's explicitly left out.

Quality rules:
- **Don't duplicate** what's already in ADRs, `CONTEXT.md`, `docs/system/feature-*.md`, or issues — **reference by path/URL**.
- **Future** tense ("we'll record…", "create the function…") — it's intent, not current state (that's `docs/system/`'s job).
- Real file/function/table names, no placeholders.
- At the top of the file, leave a status header: `> 🚧 **Status: ready to implement** — created on YYYY-MM-DD.`

### 3.1 ADRs — plan and decision work together (important)

A plan and an ADR are different things that complement each other: the **plan** is ephemeral (the *how/what* we'll do; disappears into `done/`), the **ADR** is permanent (the *why* of a hard-to-reverse decision; lives forever in `docs/adr/`). A plan **references** ADRs; it never duplicates them.

Do both ends:

1. **Existing decisions → cite the ADR.** Before writing, read `docs/adr/` (and `docs/adr/README.md`). Every recorded decision that constrains this plan must be **cited by link** in "Closed decisions" / "Current model" (e.g. "identity by CPF — see [ADR 0001](../adr/0001-...md)"). That way the implementer inherits the why without you rewriting it.

2. **New ADR-worthy decision → offer to create the ADR.** If the grilling closed a decision that is **(a) hard to reverse + (b) surprising without context + (c) a real trade-off**, it can't live only in the plan (which will be archived). **Offer to create an ADR** in `docs/adr/` (sequential numbering, format from `docs/adr/_template.md` / `README.md`) and, in the plan, **link to it** instead of repeating the rationale. All three conditions must hold — if the decision is easy to reverse or obvious, it stays in the plan only.

In short: the "durable why" goes to the ADR (and the plan points to it); the "how to execute" stays in the plan.

### 4. Update the index

Add a line for the new plan in the "Plans" section of `docs/plans/README.md` (relative link + 1-sentence summary + status).

### 5. Close out

Tell the user the path of the created plan and offer the next step (e.g. handoff to an executing agent, or implement now). If the grilling produced terms for `CONTEXT.md`, or an ADR-worthy decision you haven't recorded yet (see 3.1), remind/offer to record it before moving on — that knowledge outlives the plan.

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
- **`/grill-with-docs`** / **`/grill-me`** — the grilling session that **precedes** BUILD mode; it's where the "Closed decisions" (and the ADRs) come from.
- **`docs/adr/`** — the plan's **durable counterpart**: the plan is ephemeral (goes to `done/`), the ADR is permanent. Cite existing ADRs in the plan and promote every hard-to-reverse decision to an ADR (see step **3.1**). ADRs are **never** moved to `done/`.
- **`/sync-doc`** — this skill's **counterpart on the time axis**: `docs/plans/` is the future (what we'll do), `docs/system/` is the present (what exists). In CLOSE mode, after moving the plan to `done/`, run `/sync-doc <feature>` so the technical doc reflects what shipped.
- **`/to-pending`** — what you left in "Out of scope" or deferred during execution must not vanish: record it as a pending item in `docs/pending/` (a loose end is lighter than a plan).
- **`docs/learnings/`** — if during the plan's implementation you got bitten by a non-obvious trap, record the lesson there (not in the plan or the system doc).

Typical loop: **grill → `/to-plan` → implement → `/sync-doc` → `/to-plan done`** (+ `/to-pending` for what's left open).
