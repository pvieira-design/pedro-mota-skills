---
name: clicknotes-memory
description: Create (or update) a memory in the Click Notes knowledge base, following the org's own memory conventions so the knowledge graph stays navigable. Always pulls the live "SEMPRE LEIA" conventions block first, searches to avoid duplicates, writes the mandatory header + sections, and wires the new block into the graph (wikilinks, parent/related, hub index). Use when asked to "save this to memory", "create a memory", "registrar na base de conhecimento".
argument-hint: "<subject of the memory>"
---

# Click Notes — Create Memory

Add a durable fact/decision to the Click Notes **Memory** (the company knowledge graph) so a future AI finds it fast and lands in the right neighborhood of the graph. The Memory is a curated, opinionated structure — this skill makes sure a new block obeys it instead of becoming an orphan note.

Prerequisite: the **Click Notes MCP** is connected. Resolve `organizationId` with `list_organizations` if the user spans several orgs (omit when there's one).

## Step 0 — Pull the conventions block FIRST (non-negotiable)

The org maintains a living rulebook for its Memory. Read it every time (it can change):

`get_knowledge` with title **"SEMPRE LEIA - Como buscar, criar e atualizar memórias"** (block id `META-00-CONVENCOES`). **It is the source of truth — follow it exactly.** The summary below is just so you know what you're looking for; the block wins on any conflict.

What that block mandates (as of this writing):
- The Memory is a **hub-and-spoke + sequential graph**. The hub is `INDICE-00-PROCESSO` — read it to place the new block and pick the ID prefix.
- Every block = a **5-line metadata header** + `---` + Markdown body. Header lines: `ID do bloco`, `Resumo (1 linha)`, `Bloco-pai`, `Blocos relacionados`, `Última revisão`.
- **Stable internal ID**: `PREFIXO-NN-SLUG` (e.g. `FIN-01-COMISSOES`). Prefixes are namespaced (`INDICE/META/EMPRESA/PROC/TECH/IND/MED/FIN/MKT/GLOSSARIO`). This internal block-ID is a content convention — distinct from the MCP entry id.
- Body has **fixed-name sections** so the AI knows where to look: `## Estado atual vs. pontos de atenção (roadmap)` (gaps/risks) and `## Ferramentas envolvidas` (stack), plus a **final blockquote** isolating volatile numbers with their month/year (`> Dados de referência (mês/ano): … Revalidar periodicamente.`).
- **Reuse tags** (Title Case, with accents) — `list_knowledge_tags` first, never create a near-duplicate.

## Process

### 1. Search before creating — never duplicate

`search_company_knowledge` (and `list_knowledge`, filterable by tag/group) on the subject. If a block already covers it, **edit that block** (`edit_knowledge`) instead of creating a new one — see "Update mode" below. `add_knowledge` rejects near-duplicates anyway and returns the candidates; only pass `force: true` when you're certain it's not a dup.

### 2. Place it in the graph

- Read the hub `INDICE-00-PROCESSO` to choose the **ID prefix** and the parent (`Bloco-pai`).
- `list_knowledge_groups` → reuse an existing group path (e.g. `Click Operação`); create one only if none fits (`create_knowledge_group`).
- `list_knowledge_tags` → pick the existing tags that apply.

### 3. Write the block

Compose `content` per the mandatory template from Step 0:
- 5-line header. `Última revisão` = today (`date +%F`).
- Body sections in the project's language, with `[[wikilinks]]` to related blocks by their exact title so the graph connects.
- The fixed sections + the volatile-numbers blockquote.

`add_knowledge({ title (Title Case, unique), content, group, tags, aliases? })`.

### 4. Close the graph (the part people skip)

- **Wikilinks** in the content handle simple mentions. For **structural** edges use `link_knowledge`: `PART_OF` (this block is part of the hub/parent), `DEPENDS_ON`, or `RELATES_TO` siblings.
- If this block was listed as "(a criar)" anywhere (typically the hub `INDICE-00-PROCESSO`), **edit that index** to flip "(a criar)" → "✅" and fix the link.
- Glance at the sibling blocks you referenced — if their `Blocos relacionados` should now mention this one, update them.

### 5. Report

Give the user: the new entry's id + title, its group and tags, the internal block-ID you assigned, and the links/index edits you made to wire it in.

## Update mode (when the subject already exists)

`edit_knowledge` on the existing block — keep the template, refresh `Última revisão` to today, update the volatile-numbers blockquote, and record what changed structurally under `Estado atual vs. pontos de atenção` (preserve decision history).

> **Tag trap:** in `edit_knowledge`, the `tags` you send **replace** the current ones. Always resend the **complete** tag list (including the ones that should stay), or they're lost.

## Related skills

- **`/clicknotes-recall`** — the read counterpart: search the Memory for what's already known before you write (and to avoid duplicates).
- **`/clicknotes-meeting`** — a meeting often produces a durable decision worth promoting here.
- The CRM repo has its own file-based memory (`docs/learnings/`, `docs/adr/`) — different system. This skill is for the **Click Notes** company knowledge graph.
