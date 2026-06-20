---
name: clicknotes-meeting
description: Optimize a Click Notes meeting — read its transcript and current (weak) notes, rewrite/complement the notes faithfully, and generate the action-item tasks linked to that meeting, reusing existing tasks instead of duplicating. Use when asked to "wrap up the meeting", "improve the meeting notes", "tirar as tasks da reunião", or "optimize this meeting".
argument-hint: "<meeting id-or-title>  |  (empty = most recent meeting)"
---

# Click Notes — Optimize Meeting

Turn a raw Click Notes meeting into something useful: **better notes** (the auto-generated ones are usually thin) and **the right tasks** linked to it — without creating duplicates of tasks the org already has.

Prerequisite: the **Click Notes MCP** is connected. If the user works across several organizations, resolve the target with `list_organizations` and pass `organizationId` on every call (omit when there's only one).

## Process

### 1. Select the meeting

- **Argument given** → resolve it: `search_meetings` (by title) or `list_meetings`, then take its id.
- **No argument** → `list_meetings` (status `READY`) and take the most recent. Don't operate on a `PROCESSING`/`FAILED` meeting.

### 2. Read everything (notes + transcript)

- `get_meeting` → current notes (topics/bullets), executive summary, participants.
- `get_transcript` → the full per-speaker transcript. This is the raw truth you'll mine — the current notes are assumed incomplete and need to be complemented from here.

### 3. Find the gaps

Compare the transcript against the current notes and list what's missing or weak: decisions made, action items + owners, numbers/dates, open questions, risks, next steps. Stay faithful — only capture what was actually said; **never invent**.

### 4. Rewrite / complement the notes

`edit_meeting_notes` with clean Markdown. Respect the editor's formatting so it renders perfectly:
- `##` for each topic/section, `-` for bullets inside it (bold/italic/lists/tables allowed).
- Preserve what's already good; fill the gaps from the transcript; tighten rambling bullets.
- Write in the **meeting's language** (the team's, not English).
- Also pass an improved `summary` (executive summary) when the current one is weak.

Suggested structure: **Decisions · Action items (owner — what — due) · Numbers/facts · Open questions · Next steps**.

If the meeting maps to a project/client/theme, set its main tag with `set_meeting_tag` (use `list_tags` to reuse an existing one) — this feeds that tag's living context (`get_tag_context`).

### 5. Turn action items into tasks — dedupe, don't duplicate

For each action item you extracted, **check the board before creating**:

1. **Look for an existing equivalent task.** `list_tasks` (status `OPEN` and `IN_PROGRESS`); if the meeting has a tag, `get_tag_context(tag)` surfaces that theme's active/pending tasks. Match by intent, not exact wording.
2. **If it already exists → update it, don't recreate.** `update_task` (refresh description/`dueDate`/`priority`), `update_task_status` if it moved, and `add_task_comment` noting it resurfaced — e.g. *"Reafirmada na reunião «\<title\>» (\<date\>): \<what changed\>."* This is how the same task spans multiple meetings.
   > Note: the MCP links a task to its origin meeting only at creation (`create_task.meetingId`); there's no field to attach an existing task to a second meeting. So the cross-meeting link is recorded in the comment/description above.
3. **If it's genuinely new → create it.** `create_task` with `meetingId` = this meeting, a clear `title`, `description` (context + acceptance), `priority`/`dueDate` when stated, and the assignee — a member (`assigneeId`, via `list_members`) or external contact (`assigneeContactId`, via `list_contacts`). Group it with `groupId` (via `list_task_groups`) if a project group fits.

### 6. Report

In a few lines: what you improved in the notes (the gaps you closed), the tag you set, and a tally of **tasks created vs. tasks updated (deduped)** — listing each with its id and assignee. Flag any action item you left out because it was ambiguous.

## Notes

- Faithful over complete: if the transcript doesn't support a bullet, drop it.
- Dedupe is the point — a second meeting that revisits the same work should **update** the existing task, not spawn a twin.
- This skill doesn't touch the knowledge base. To capture a durable decision from the meeting as a Memory block, use `/clicknotes-memory`.

## Related skills

- **`/clicknotes-tasks`** — sweep the board later to reconcile statuses (mark done / update partial) for the tasks this skill created.
- **`/clicknotes-memory`** — promote a durable decision or fact from the meeting into the Click Notes Memory (knowledge graph).
- **`/clicknotes-recall`** — before the meeting follow-up, pull what the Memory already knows about the topic.
