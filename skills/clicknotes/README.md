# Click Notes skills

Skills that drive the **Click Notes MCP** — the company's meetings, notes, tasks, and curated knowledge graph ("Memória"). Grouped here so the Click Notes surface is documented in one place; each skill is still invoked by its own name (`/clicknotes-*`).

All of these are **org-aware**: every Click Notes MCP tool accepts an optional `organizationId`. With one org, omit it. With several, resolve the id via `list_organizations` and pass it on every call — you only see one org's data at a time.

## The skills

| Skill | What it does |
|---|---|
| **`clicknotes-meeting`** | Read a meeting's transcript + current (thin) notes → rewrite/complement the notes faithfully, and turn action items into tasks linked to the meeting, **deduping** against tasks the org already has. |
| **`clicknotes-memory`** | Create/update a block in the Memory, obeying the org's living conventions (`META-00-CONVENCOES`): mandatory header, stable `PREFIXO-NN-SLUG` id, fixed sections, reused tags, and graph wiring (wikilinks + `link_knowledge` + hub index). |
| **`clicknotes-recall`** | Search the Memory for the current topic, walk the graph (wikilinks, parent/related, backlinks, tag context), and ground the conversation. Read-only. |
| **`clicknotes-tasks`** | Reconcile the board: review open tasks against what's actually done and update each (COMPLETED, or IN_PROGRESS with what remains). Evidence-based. |

## The MCP feature surface (what these skills lean on)

**Meetings** — `list_meetings`, `search_meetings`, `get_meeting` (notes + summary + participants), `get_transcript` (raw per-speaker), `edit_meeting_notes` (rewrite notes as Markdown: `##` topics, `-` bullets), `set_meeting_tag`.

**Tasks** — `list_tasks` (flat list, `parentId` marks subtasks; filter by status), `get_task` (full + subtasks + comments), `create_task` (with `parentId` for subtasks, `meetingId` to link a meeting, `groupId` for a project, member/contact assignee), `update_task`, `update_task_status` (`OPEN`/`IN_PROGRESS`/`COMPLETED`), `assign_task`, `add_task_comment`, `set_task_parent`, `move_task_to_group`, task groups (`list_task_groups`, `create_task_group`), soft-delete/restore.

> Task ↔ meeting linkage is set **only at creation** (`create_task.meetingId`) — there's no field to attach an existing task to a second meeting. So `clicknotes-meeting` records cross-meeting reuse via an update + comment on the existing task rather than a duplicate.

**Knowledge / Memória** — `search_company_knowledge`, `list_knowledge` (by tag/group), `get_knowledge` (full + outgoing `[[wikilinks]]` + backlinks), `add_knowledge`, `edit_knowledge` (⚠ tags sent **replace** current — resend the full list), `link_knowledge` (`PART_OF`/`DEPENDS_ON`/`RELATES_TO`), groups (`list_knowledge_groups`, `create_knowledge_group`, `move_knowledge`), tags (`list_knowledge_tags`, `create_knowledge_tag`), and `get_tag_context` (living accumulated context for a tag, synthesized across meetings).

The Memory is a **curated graph**, not a note pile: a hub (`INDICE-00-PROCESSO`), stable block IDs, fixed sections, and a conventions block (`META-00-CONVENCOES`, title *"SEMPRE LEIA …"*) that `clicknotes-memory` reads live before writing.

Also available on the MCP (not yet wrapped by a skill): standalone notes (`create_note`/`edit_note`/…), docs (`create_doc`/`search_docs`/…), contacts (`list_contacts`/`create_contact`/…), members (`list_members`).
