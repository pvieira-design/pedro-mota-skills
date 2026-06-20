---
name: clicknotes-recall
description: Search the Click Notes Memory (company knowledge graph) for what's relevant to the subject being discussed right now, walk the graph (wikilinks, parent/related, backlinks, tag context), and ground the conversation in what the org already knows. Read-only. Use when asked "what do we know about X", "check the memory", "busca na base de conhecimento", or proactively before answering a domain question.
argument-hint: "<topic>  |  (empty = infer from the conversation)"
---

# Click Notes — Recall Memory

Pull the useful memories about the current topic before reasoning or answering, so the chat is grounded in the org's curated knowledge instead of guesses. **Read-only** — it never writes.

Prerequisite: the **Click Notes MCP** is connected. Resolve `organizationId` with `list_organizations` if the user spans several orgs.

## Process

### 1. Frame the query

Use the argument if given; otherwise infer the subject and a few keyword phrasings from the current conversation. Note whether it's a **specific** topic (one block likely) or **transversal** (a theme/tag spanning many).

### 2. Search broadly

- `search_company_knowledge(query, limit)` — run 2-3 phrasings; results are ranked, content included.
- For transversal topics, also `list_knowledge` filtered by `tag` and/or `group` (path like `Click Operação`) to sweep titles + 1-line summaries cheaply.

### 3. Walk the graph (don't stop at the first hit)

For the most relevant hits, `get_knowledge` (by id or title) to read in full — and follow the edges it returns:
- `[[wikilinks]]` in the body, the header's **Bloco-pai** and **Blocos relacionados** lines, and the **backlinks** (who points at this block).
- When unsure where something lives, start at the hub `INDICE-00-PROCESSO` (the map) and navigate down by ID prefix.

### 4. Pull living context for themes

If the topic maps to a meeting tag (project/client/theme), `get_tag_context(tag)` returns the **accumulated** state synthesized across all meetings with that tag — summary, decisions, active/done tasks, pending items, people. Great for "where does this stand".

### 5. Synthesize and ground

Present, tightly:
- The relevant blocks: **title — 1-line — why it's relevant** (cite the internal block-ID, e.g. `PROC-03`).
- The connections that matter (this depends on / is part of / contradicts that).
- Any **volatile number** with its reference date (from the block's blockquote) so the user knows its freshness.

If nothing relevant exists, say so plainly — and offer `/clicknotes-memory` to capture it if the current discussion produced something worth keeping.

## Notes

- Prefer reading the graph over dumping raw search output — the value is the **connected** picture.
- Watch the `Última revisão` date and the volatile-numbers blockquote; flag anything that looks stale rather than presenting it as current.

## Related skills

- **`/clicknotes-memory`** — the write counterpart: create/update a block when recall finds a gap.
- **`/clicknotes-meeting`** — pulls related tasks/decisions for a specific meeting (different entry point: a meeting, not the knowledge graph).
