# Knowledge base structured in `docs/`

We decided, from the start of the project, to keep durable knowledge in the repository instead of leaving it scattered across code, issues and people's heads. It has parts with distinct roles: `CONTEXT.md` (domain glossary), `docs/adr/` (decisions and their whys), `docs/system/` (living technical docs — what the code does today), and `docs/learnings/` (mistakes already made, not to repeat). Approved future work lives in GitHub specs and tickets; deferred loose ends live as GitHub issues labelled `pending`.

The why: every new task gets cheaper and safer when the agent or human understands a feature by reading a page instead of scanning the code, does not reopen decisions already made, and does not repeat mistakes already paid for. The cost is keeping the durable docs current — mitigated by `/sync-doc`, `/to-spec`, `/to-pending` and `/grill-with-docs`, which make maintenance part of "work done".

## Consequences

- The technical docs (`docs/system/`) must never diverge from the code: when a feature is finished, run `/sync-doc`.
- Hard-to-reverse decisions become an ADR here; pinned vocabulary goes to `CONTEXT.md`.
