---
name: improve-codebase-architecture
description: Audit a codebase for high-value deep-module refactors, using the project's domain language and architectural decisions. Invoke manually when the user explicitly wants architecture improvement candidates; do not trigger automatically during ordinary implementation or review.
disable-model-invocation: true
---

# Improve Codebase Architecture

Perform a read-only architecture audit. Find a small number of changes that would increase locality, leverage, testability and AI navigability. Do not edit source code or publish tracker items unless the user separately asks.

## 1. Ground the audit

Read the repository instructions and its documented map before exploring code. Then read the domain glossary, relevant ADRs, living feature documentation and architectural learnings. If `codebase-design` is installed, load it for the shared vocabulary and deep-module principles.

State the audited scope. If the user did not name one and the repository is too large for a credible whole-codebase review, ask for a bounded area.

## 2. Inspect real seams

Trace representative behavior through callers, interfaces, implementations, persistence and tests. Look for evidence, not abstract preferences:

- shallow modules whose interface is nearly as complex as their implementation;
- related rules scattered across callers instead of concentrated behind one interface;
- pass-through layers that fail the deletion test;
- dependencies created internally that make behavior hard to replace or test;
- seams with only one adapter and no demonstrated variation;
- tests coupled to implementation details because the public interface is the wrong test surface;
- domain concepts whose code names or ownership conflict with the canonical vocabulary.

Reuse the repository's documented terminology. Do not relitigate an ADR unless current code provides concrete evidence that its trade-off changed.

## 3. Rank candidates

Report only evidence-backed candidates. For each one include:

- exact files and symbols;
- present interface and why it is shallow or misplaced;
- proposed deeper module and its intended seam;
- behavior that moves behind the interface;
- expected locality, leverage and testability gain;
- migration risk and likely blast radius;
- confidence: `strong`, `worth exploring` or `speculative`.

Apply the deletion test explicitly. Distinguish a real seam with multiple adapters from a hypothetical seam introduced only for tests.

## 4. Stop at the decision boundary

Recommend the single best next candidate and explain why it outranks the rest. Do not design the final interface, edit code or start implementation automatically. If the user chooses a candidate, use the repository's smallest valid route: direct work when it is already simple and decided, direct `to-spec` for a complete brief that needs an AFK contract, a standalone grill for a genuine bounded decision, or Wayfinder when planning is both multisession and still foggy.
