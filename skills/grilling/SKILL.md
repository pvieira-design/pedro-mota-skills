---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea after grounding in the project's existing documentation. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview me relentlessly about every aspect of this until we reach a shared understanding. Walk down each branch of the decision tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Before the first question, read the repository's agent instructions and knowledge base. When `docs/system/README.md` exists, use its topic map to read the target feature-doc and the adjacent/complementary feature-docs that interact with the subject; then read relevant `CONTEXT.md`, ADRs, learnings and pending items. Inspect the specific code paths named by those docs only as needed to verify facts. Briefly distinguish established facts from genuine unknowns, and never ask the user a factual question the repository can answer.

Ask the questions one at a time, waiting for feedback on each question before continuing. Asking multiple questions at once is bewildering.

If a *fact* can be found by exploring the environment (filesystem, tools, etc.), look it up rather than asking me. The *decisions*, though, are mine — put each one to me and wait for my answer.

Do not act on it until I confirm we have reached a shared understanding.
