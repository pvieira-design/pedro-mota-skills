---
name: grill-with-docs
description: A docs-grounded, relentless interview to sharpen a plan or design, recording a standalone grilling session and creating durable docs (ADRs and glossary) as decisions close.
disable-model-invocation: true
---

Before the first question, read the repository instructions and knowledge base. If `docs/system/README.md` exists, use its topic map to read the target feature-doc plus adjacent/complementary feature-docs, then relevant `CONTEXT.md`, ADRs, learnings and pending items. Summarize established facts and genuine unknowns; do not ask the user for facts the repository can answer.

For a standalone session in a repo that uses Pedro's docs structure, create one timestamped `docs/grills/YYYY-MM-DD-HHmm-<detailed-topic>.md` before the first question and record the grounding sources, Q&A, dropped hypotheses and open points live. Casual design conversations do not create this file. If the current work is a Wayfinder ticket, use the tracker ticket/comments as the trail and do not create a duplicate local grill.

Run a `/grilling` session, using the `/domain-modeling` skill. Ask one decision at a time. As decisions close, move durable vocabulary to `CONTEXT.md`, hard-to-reverse trade-offs to ADRs and future work to a plan; update `docs/system/` only after the corresponding code changes.
