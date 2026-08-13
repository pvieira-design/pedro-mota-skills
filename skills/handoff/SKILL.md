---
name: handoff
description: Compact the current conversation into a handoff document and a ready-to-paste prompt under the project's hidden .handoff/ folder. Use for direct session-to-session transfer when the issue-driven queue is unnecessary, or to continue a Wayfinder, grilling or tracker thread in a fresh chat.
---

# Handoff

Create two ephemeral Markdown files under the repository root's `.handoff/` folder: a detailed handoff and a short ready-to-paste prompt. Open the prompt when done.

`handoff` is a **direct-session alternative**, not a replacement for the standard approved-spec → `to-tickets` → one-ticket-per-`implement` flow. Prefer tracker tickets when work is shared, concurrent, blocked or needs durable operational state.

## 1. Determine the purpose

Infer one purpose; ask one short question only if genuinely ambiguous:

- **Continue standalone grilling/specification** — decisions remain open and a GitHub issue labelled `grill:session` exists.
- **Continue Wayfinder** — a tracker map or decision ticket remains open. The tracker is the trail; there is no local grill.
- **Continue tracker execution** — an approved spec or executable child issue already exists.
- **General continuation** — none of the above.

## 2. Ground the handoff

Read root `AGENTS.md` and `CLAUDE.md`, then reference only artifacts that exist:

1. `docs/system/README.md`, the target feature-doc and complementary feature-docs;
2. `CONTEXT.md` and relevant ADRs;
3. the active GitHub spec and implementation issue, when present;
4. relevant open GitHub issues labelled `pending` and `docs/learnings/` items;
5. for standalone grilling, the exact `grill:session` issue, including its current body, every comment and linked artifact;
6. for Wayfinder, the map URL/number and current ticket URL/number.

Do not duplicate those artifacts. Point to the sources of truth. The current session chat and internal Orca messages are approved channels for sensitive values needed by the task, but handoff files, GitHub, commits, publishable patches and public logs are not. Keep only non-sensitive consequences or safe references in the handoff; never persist secrets, credentials, PII or raw sensitive payloads. Do not invent an indirect handoff between the two approved channels.

## 3. Write the files

Ensure `.handoff/` is in `.gitignore`. Use `date +%Y-%m-%d-%H%M` and a detailed topic slug:

- `.handoff/<timestamp>-<slug>.md` — detailed state;
- `.handoff/<timestamp>-<slug>-prompt.md` — prompt for the new chat.

The detailed handoff contains: purpose, goal, completed/in-progress/blocked state, closed and open decisions, ordered reading list, exact next action, risks and the suggested skill names.

## 4. Tailor the prompt

Every prompt must tell the new agent to read the handoff, `AGENTS.md`/`CLAUDE.md`, and the ordered knowledge-base list before acting.

- **Standalone grilling:** resume the same `grill:session` issue, preserve each substantive round in a chronological comment, refresh the issue-body checkpoint before the next question, do not code, then use `to-spec` once decisions close.
- **Wayfinder:** load the map and current ticket, keep all operational reasoning in tracker comments, resolve no more than one non-research ticket, do not create `docs/grills/`, then use `to-spec` when the route is fully clear.
- **Tracker execution:** read the executable issue, parent spec and cited docs; follow `implement` claim, checks, review, proof and closure gates. Record deferrals with `to-pending`.
- **General:** state the exact next action without inventing a workflow.

Use the repository's working language. Mention both explicit syntaxes only when useful: Claude Code uses `/skill-name`; Codex uses `$skill-name` or `/skills`.

## 5. Open and report

Open the prompt with `open` on macOS or `xdg-open` on Linux. Report in at most four lines: purpose, both paths and that the prompt is ready.
