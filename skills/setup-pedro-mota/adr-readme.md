# Architecture decisions (`docs/adr/`)

**ADRs (Architecture Decision Records)** — the record of *why* the system is the way it is. Every decision that's hard to reverse, surprising, or the result of a real trade-off becomes a numbered file here, so no one (human or agent) reopens the discussion or "fixes" something that was deliberate.

> **Why it matters:** the code shows the *how*, not the *why*. Without an ADR, six months from now someone suggests again the alternative you already rejected. The ADR is the memory of decisions.

## When to write an ADR

All **three** must be true:

1. **Hard to reverse** — changing your mind later is costly.
2. **Surprising without context** — a future reader will look at the code and think "why on earth did they do it this way?".
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons.

If any fails, skip the ADR. Examples that qualify: architectural shape (monorepo, event-sourcing), integration pattern between contexts, technology choice with lock-in, boundary/scope decisions, deliberate deviations from the obvious path, constraints not visible in the code.

## Convention

- Sequential numbering: `0001-slug.md`, `0002-slug.md`… (take the highest existing number and increment).
- Minimal format (see [`_template.md`](_template.md)): title + 1-3 sentences (context, what was decided, why). A single paragraph is enough. The value is in recording *that* the decision existed and *why* — not in filling out sections.
- Optional sections (`Status`, `Considered options`, `Consequences`) only when they add value.

Decisions are often pinned during a `/grill-with-docs` session — it offers to create the ADR on the spot.

## ADRs

- [`0001-knowledge-base-in-docs.md`](0001-knowledge-base-in-docs.md) — keep the knowledge base structured in `docs/` (system/plans/pendencias/aprendizados + CONTEXT.md + ADRs).
