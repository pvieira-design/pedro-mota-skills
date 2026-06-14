---
name: sync-doc
description: At the end of working on a feature, sync the feature's doc with the code (create if missing, update if it diverged). Optional argument: feature name.
argument-hint: "[feature-name]"
---

You were invoked via `/sync-doc`. The user finished working on a feature and wants to make sure the documentation reflects the reality of the code. **That's your only mission** — don't make other code changes.

> This is the **global** version of the command. If the project has its own version at `<repo>/.claude/commands/sync-doc.md`, that one wins — follow its instructions. This version is the generic fallback.

> **Role in the ecosystem:** `docs/system/` is the **living technical doc** — the source of truth for what the code does TODAY, written so anyone (human or agent) understands a feature by **reading the page** instead of scanning the code. You are the one who keeps it in sync. The sibling folders have other owners and tenses: `docs/plans/` (what we're still **going** to do — skill `/to-plan`) and `docs/pending/` / `docs/learnings/` (loose ends / lessons from mistakes). The whole structure is installed by `/setup-pedro-mota`. **Don't** write a plan or a lesson here — only the current state of the code.

## Step 0 — Detect the project's convention

Before anything, find out **where** the docs live in this project. Run in parallel:

- `ls docs/system/ 2>/dev/null` — preferred convention (one file per feature)
- `ls docs/ 2>/dev/null`
- `ls documentation/ 2>/dev/null`
- `ls AGENTS.md CLAUDE.md README.md 2>/dev/null`
- `git ls-files '*.md' | head -50` — existing docs pattern

In priority order, pick the target directory:
1. `docs/system/` if it exists (preferred convention — one file per feature)
2. `docs/features/`, `docs/architecture/`, or `docs/` if they exist
3. `documentation/`
4. If nothing exists: **ask the user** where to keep it (`docs/system/` is a good default; offer to create it)

Also look for:
- A root `CLAUDE.md` or `AGENTS.md` with a **feature map** (a table or list of "feature → doc"). If there is one, use it as the canonical index.
- A `_template.md` or `TEMPLATE.md` in the docs directory — follow it if it exists.

If the project has **no docs-per-feature convention** at all, tell the user and offer:
- (a) run **`/setup-pedro-mota`** first — it does the full bootstrap (`docs/system/` + `docs/plans/` + `docs/pending/` + `docs/learnings/` + READMEs/templates + blocks in CLAUDE.md). This is the recommended path; then come back to `/sync-doc`.
- (b) write the feature's doc at a path they indicate (without the full structure).

## Step 1 — Figure out the feature

If the user passed an argument, use it as `<feature>`.

If not, run **in parallel**:

- `git status --short` — modified/new files
- `git diff --stat HEAD~10 HEAD` — recent changes
- `git log --oneline -10` — recent commits

Based on the changed paths, identify the feature using the project's canonical index (CLAUDE.md / AGENTS.md / docs README). If ambiguous (several features touched, or a new feature with no mapping), **ASK the user** which to document. Don't guess. If multiple were touched, tackle one at a time.

## Step 2 — Decide CREATE vs UPDATE

```
ls <docs-dir>/<feature>.md
```

Exists → follow **UPDATE**. Doesn't exist → follow **CREATE**.

---

## UPDATE path (doc already exists)

1. Read the current doc.
2. Read the files touched in the diff (focusing on those affecting the doc's description: routers/handlers, schemas, main screens/routes, central libs/utils).
3. **Compare claim by claim**:
   - Do the listed endpoints/procedures still exist? Does the signature match?
   - Do the files cited in "Key files" / "Files" exist at the described path?
   - Are the mentioned tables/columns still in the schema?
   - Do the business rules (TTLs, limits, validations, execution order) still hold?
   - Do the function/helper names match?
   - Do the external dependencies (third-party APIs, env vars, integrations) still match?
4. Produce a **concrete list of discrepancies** (not generic). Good example: "doc says `zoom-morph-shell.tsx` but the file is `zoom-shell.tsx`". Bad example: "doc is outdated".
5. **Show the discrepancies to the user BEFORE applying** — including the ones you just want to bump. Format:
   ```
   Discrepancies found in <feature>.md:
   1. [line X] Y → Z
   2. [new rule] W
   Proposed additions:
   - ...
   Apply?
   ```
6. Apply after approval.
7. **Bump** `## Last updated` (or equivalent section) with the **real reason** for the change (not "generic update"). E.g. `2026-04-29 — added endpoint /v2/x; fixed file names`.

---

## CREATE path (doc doesn't exist)

1. Read the project's template if it exists (`_template.md`, `TEMPLATE.md`). Otherwise, use the skeleton below.
2. Explore the feature's code in order (adapt to the project's paths):
   - **Screens/routes/endpoints:** list all relevant routes
   - **API/router layer:** extract each handler/procedure with name + input + auth gate
   - **Schema/persistence:** tables, columns, indexes
   - **Central libs/utils** the feature uses
   - **Key components** (if it's UI)
   - **External integrations** (Stripe, Strapi, Resend, R2, etc.)
3. For each template section, fill in **real names**. **Every name cited must pass `git grep`** — if it doesn't, don't write it.
4. For business rules and the "why" (not derivable from the code), **ASK the user** with specific questions. Examples:
   - "Why is the TTL X and not another value?"
   - "What happens if step Y fails?"
   - "Which rule decides when the item shows up in list A vs B?"

   Generic questions ("what are the business rules?") are bad — always specific.
5. Write the doc.
6. **Update the project index** if it exists:
   - `docs/system/README.md` — add the feature to the **"Topic map"** table (a "Looking for… → doc(s) → ADR" row) **and** to the "Documents" list. The "Topic map" is the index the next agent reads first; a feature with no row there is an invisible feature.
   - root `CLAUDE.md` / `AGENTS.md` — if it has a "feature → doc" map, replace the placeholder with the new doc's link.

### Fallback skeleton (if there's no `_template.md`)

```markdown
# <Feature>

## Last updated: YYYY-MM-DD — <reason>

## What it is
<2-3 lines of description>

## Where it lives
- Screen/route: `path/to/screen-or-route`
- Backend handler: `path/to/handler`
- Schema: `path/to/schema`

## API / procedures
- `name.of.handler(input)` — gate: `<auth>` — description

## Business rules (non-obvious)
- ...

## External dependencies
- ...

## Key files
- `path/to/file.ext` — role
```

---

## "Perfect for understanding" criterion

Before declaring it done, run this checklist:

- [ ] **Existence:** every file, function, procedure, table cited passes `git grep`
- [ ] **No placeholders:** no section was left with `(...)` or the template's example text
- [ ] **"Last updated"** has today's date + a real reason (not "update")
- [ ] **Cross-feature:** if the change affected another feature (e.g. a reused helper, a new shell), mention it in THAT feature's doc too
- [ ] **Index updated** if it's a new doc: the **"Topic map"** table + "Documents" list in the docs README, and the root CLAUDE.md/AGENTS.md
- [ ] **Routers/endpoints listed** are actually registered/exposed

"Perfect" test: someone who has never seen the code should be able to answer, from the doc alone:

1. Where does it live? (paths)
2. What does it do? (2-3 lines)
3. Which APIs/handlers does it involve?
4. What non-obvious rules exist? (TTLs, limits, quirks)
5. What external dependencies does it use?

No prose. Bullets > paragraphs. Real names > placeholders.

---

## Final step — Report

Reply to the user in ≤5 lines:

- Action: `UPDATE` or `CREATE` + doc name + path
- The "Last updated" line written
- If something was left pending due to a missing user answer, say what

If the user didn't answer a business-rule question, **mark the section with an explicit TODO** in the doc instead of inventing:

```markdown
## Business rules
- TODO(sync-doc YYYY-MM-DD): Ask the user why the TTL is 60s
```

That way the next session knows human context is missing.

---

## If you got bitten by a trap (`docs/learnings/`)

If during this feature's work you (or the user) **lost time on a bug with a non-obvious cause, an environment/tool trap, or a wrong path** — that does not go to `docs/system/` (which describes the code, not the stumbles). Offer to record a **lesson** in `docs/learnings/` (format: what went wrong · why · the rule not to repeat). Worth it when: it cost time + tends to recur + has an actionable rule. Don't invent a lesson if there was no real stumble.

## Related skills (the ecosystem)

`/sync-doc` is one piece of a loop. The others:

- **`/setup-pedro-mota`** — installs the structure (`docs/system/` + `docs/plans/` + `docs/pending/` + `docs/learnings/` + CLAUDE.md). Run it if the convention doesn't exist yet.
- **`/grill-with-docs`** / **`/grill-me`** — grilling session that stress-tests the plan.
- **`/to-plan`** — distills the grilling into a plan in `docs/plans/`; `/to-plan done <slug>` archives the plan when the feature ships.
- **`/to-pending`** — records loose ends in `docs/pending/`. If while syncing the doc you notice something deferred/open, suggest recording the pending item so it's not forgotten.

Typical loop: **grill → `/to-plan` → implement → `/sync-doc` (you) → `/to-plan done`** (+ `/to-pending` for what's left open). When you finish `/sync-doc` for a plan that existed in `docs/plans/`, remind the user to close it with `/to-plan done <slug>`.
