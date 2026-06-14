---
name: handoff
description: Compact the current conversation into a handoff document, then write a ready-to-paste prompt as a markdown file under the project's hidden .handoff/ folder and open it so the user can copy it. The prompt is tailored to the handoff's purpose — continuing a grilling/planning session, or executing a plan — and is wired to the repo's knowledge base (CONTEXT.md, docs/adr, docs/system, docs/plans, docs/pending, docs/learnings).
argument-hint: "What will the next session be used for?"
---

Produce a handoff so a fresh agent can continue the work, as **two markdown files in a hidden project folder** (`.handoff/`): the **handoff doc** (the detailed summary) and the **prompt** (what the user pastes into the next chat). When done, **open the prompt file** so the user can copy it.

## 1. Determine the purpose (this shapes the prompt)

A handoff is for one of (infer from the user's argument and the conversation; if genuinely unclear, ask one short question):

- **Continue grilling / planning** — the design isn't settled yet. The next session keeps stress-testing decisions and shaping the plan. It is NOT ready to write code.
- **Execute a plan** — a plan already exists (in `docs/plans/`) or the decisions are closed. The next session implements it.
- **Other / general** — neither cleanly applies; write a general continuation.

The prompt's instructions differ per purpose (see step 4).

## 2. Pick the location

Use a hidden folder at the **repo root**: `.handoff/`. Create it if missing. Add `.handoff/` to `.gitignore` if it's not already there — these are ephemeral session artifacts, not committed docs.

Get a timestamp slug: `date +%Y-%m-%d-%H%M`. Base filename: `<timestamp>-<short-slug>` (slug from the topic/argument). Two files:

- `.handoff/<base>.md` — the handoff doc.
- `.handoff/<base>-prompt.md` — the prompt (the one you open).

## 3. Write the handoff doc

`.handoff/<base>.md`, tailored to the purpose. Let a fresh agent continue with zero prior context. Include:

- **Purpose** — continue grilling/planning, or execute (from step 1).
- **Goal / next focus** — what the next session is for.
- **State so far** — what's done, in progress, blocked. For grilling/planning: which decisions are closed and which are still open. For execution: what's the plan and what's left.
- **Knowledge base to read first** — see step 3.1.
- **Suggested skills** — which to invoke (e.g. `/grill-with-docs` + `/to-plan` for planning; implement + `/sync-doc` + `/to-plan done` for execution).
- **Open loops / risks** — pending decisions, things to watch.

Rules:
- **Don't duplicate** content already in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). **Reference them by path** — redirect the next agent to the source of truth, don't copy it.
- **Redact** sensitive info (API keys, passwords, PII).

### 3.1 Wire it to the repo's knowledge base

Detect which knowledge-base artifacts exist (only reference what's there) and build an ordered reading list with real paths:

- `CONTEXT.md` / `CONTEXT-MAP.md` — domain vocabulary.
- `docs/adr/` — decisions (the *why*). Cite the specific ADRs that constrain the next task.
- `docs/system/` — living technical docs. Point at `docs/system/README.md` ("Topic map") + the specific `feature-*.md` for the area.
- `docs/plans/` — work plans. Name the **active plan** if there is one.
- `docs/pending/` — open loose ends. Link any relevant one.
- `docs/learnings/` — past mistakes. Link any that apply.

If the repo has none of this structure, suggest running `/setup-pedro-mota` first.

## 4. Write the prompt file (tailored to the purpose)

`.handoff/<base>-prompt.md` — a single, self-contained prompt the user copies verbatim into a new chat. Write it in the user's working language. Paths are repo-relative (the next chat runs in the repo); reference the handoff doc as `.handoff/<base>.md`.

Every prompt: (a) states the goal, (b) tells the agent to read `.handoff/<base>.md` first, (c) then the knowledge-base reading list from 3.1, (d) reminds it to follow the repo conventions (CLAUDE.md / AGENTS.md).

Then tailor the action by purpose:

- **Continue grilling/planning:** instruct the agent to **resume the design session** — re-open the still-undecided questions (list them), stress-test them, and NOT jump to code. Suggested skills: `/grill-with-docs` (keep challenging against the domain, update `CONTEXT.md`/ADRs as decisions close) and, once settled, `/to-plan` to capture the plan.
- **Execute a plan:** instruct the agent to **implement the plan** at `docs/plans/<...>.md` — read it plus the cited ADRs and `feature-*.md`, respect the invariants, and when done run `/sync-doc` on the touched feature and `/to-plan done <slug>` to archive the plan. Register `/to-pending` for anything deferred and a lesson in `docs/learnings/` if bitten.
- **Other:** a general continuation pointing at the handoff doc + reading list.

Keep it tight and self-contained — real, clickable paths.

## 5. Open the prompt and report

Open the prompt file so the user can copy it:

- macOS: `open .handoff/<base>-prompt.md`
- Linux: `xdg-open .handoff/<base>-prompt.md` (fallback: just print the path)

Then tell the user, in ≤4 lines: the purpose detected, the two file paths, and that the prompt is open and ready to paste into a new chat.

## Related skills

`/handoff` is the exit of the work loop — it passes the baton to another session pointing at the knowledge base that **`/setup-pedro-mota`** installed and that **`/grill-with-docs`**, **`/to-plan`**, **`/sync-doc`** and **`/to-pending`** maintain. Before handing off, consider closing what you can so the handoff points at a clean state: `/sync-doc` on the touched feature, `/to-plan done` on an implemented plan, `/to-pending` for what's left open.
