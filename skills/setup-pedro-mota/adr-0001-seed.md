# Knowledge base structured in `docs/`

We decided, from the start of the project, to keep a structured knowledge base in `docs/` instead of leaving knowledge scattered across code, PRs, and people's heads. It has parts with distinct roles: `CONTEXT.md` (domain glossary), `docs/adr/` (decisions and their whys), `docs/system/` (living technical docs — what the code does today), `docs/plans/` (plans for what we're going to do), `docs/pendencias/` (loose ends to revisit), and `docs/aprendizados/` (mistakes already made, not to repeat).

The why: every new task gets cheaper and safer when the agent/human understands a feature by reading a page instead of scanning the code, doesn't reopen decisions already made, and doesn't repeat mistakes already paid for. The cost is keeping the docs current — mitigated by the `/sync-doc`, `/to-plan`, `/to-pending` and `/grill-with-docs` skills, which make maintenance part of "work done".

## Consequences

- The technical docs (`docs/system/`) must never diverge from the code: when a feature is finished, run `/sync-doc`.
- Hard-to-reverse decisions become an ADR here; pinned vocabulary goes to `CONTEXT.md`.
