---
name: code-review
description: Review changes since a fixed point (commit, branch, tag, or merge-base) along two separate axes — Standards (does the diff follow the repository's documented coding standards?) and Spec (does it implement the originating issue, PRD, or spec?). Run both passes sequentially in the current agent. Use when the user wants to review a branch, PR, work-in-progress changes, or asks to "review since X".
---

Review the diff between `HEAD` and a fixed point along two axes:

- **Standards** — does the code conform to this repository's documented coding standards?
- **Spec** — does the code faithfully implement the originating issue, PRD, or spec?

Perform the entire review in the current agent. Complete and freeze the Standards findings before opening the spec and beginning the Spec pass. Report the axes separately so one cannot mask the other.

This is Pedro Mota's sequential adaptation of `mattpocock/skills@v1.2.3`.

The issue tracker should have been provided to you — run `/setup-matt-pocock-skills` if `docs/agents/issue-tracker.md` is missing.

## Process

### 1. Pin the fixed point

Use the fixed point supplied by the user: a commit SHA, branch, tag, `main`, `HEAD~5`, or equivalent. Ask for it when absent.

Capture the comparison once:

```text
git diff <fixed-point>...HEAD
git log <fixed-point>..HEAD --oneline
```

Confirm that the fixed point resolves with `git rev-parse <fixed-point>` and that the diff is non-empty. Stop on an invalid ref or empty diff.

### 2. Identify the standards sources

Find the repository instructions that govern the changed paths, including `AGENTS.md`, `CLAUDE.md`, `CODING_STANDARDS.md`, `CONTRIBUTING.md`, and referenced documentation.

Apply the repository's rules first. Also use the smell baseline below when tooling or repository rules do not already settle the point:

- **Mysterious Name** — a function, variable, or type whose name does not reveal its purpose. Rename it; if no honest name fits, clarify the design.
- **Duplicated Code** — the same logic shape appears in multiple changed sites. Extract the shared shape when the semantics truly match.
- **Feature Envy** — a method reaches into another object's data more than its own. Move the behavior toward the data it uses.
- **Data Clumps** — the same fields or parameters repeatedly travel together. Bundle the domain concept into one type.
- **Primitive Obsession** — a primitive or string stands in for a domain concept. Give the concept a focused type.
- **Repeated Switches** — the same branch cascade over the same kind appears repeatedly. Centralize it with polymorphism or one shared map.
- **Shotgun Surgery** — one logical change requires scattered edits. Gather the behavior into one module.
- **Divergent Change** — one module changes for unrelated reasons. Separate those responsibilities.
- **Speculative Generality** — abstractions, parameters, or hooks serve no current requirement. Remove them until a real need exists.
- **Message Chains** — callers navigate long object chains. Hide the traversal behind a focused method.
- **Middle Man** — a function or class mainly delegates onward. Call the real target directly.
- **Refused Bequest** — an implementer ignores most inherited behavior. Prefer composition.

Repository standards override the baseline. Treat baseline smells as judgement calls, not hard violations, and skip findings that automated tooling already enforces.

### 3. Complete the Standards pass

Read every changed file and relevant hunk using the pinned diff. Account for the repository rules and the smell baseline across the whole diff.

For each finding:

- cite the changed file and hunk or line;
- cite the repository rule when it is a documented violation;
- name the smell when it is a baseline judgement call;
- explain the concrete risk and smallest useful correction.

Freeze the Standards findings when every changed file and applicable rule has been considered. Keep the pass under 400 words.

### 4. Identify the spec and complete the Spec pass

Only after freezing Standards, locate the originating spec in this order:

1. GitHub issue references in commit messages (`#123`, `Closes #45`, and equivalents), fetched through `docs/agents/issue-tracker.md`;
2. a path supplied by the user;
3. a PRD or spec under `docs/` or `specs/` matching the branch or feature;
4. the user's confirmation that no spec exists.

When the source is ambiguous, ask which source governs the change. When no spec exists, mark this axis as unavailable instead of inventing requirements.

Map every stated requirement to the diff and account for changed behavior that has no matching requirement. Report:

- requirements that are missing or partial;
- behavior outside the requested scope;
- implementation that appears present but contradicts the requirement.

Quote or precisely cite the governing requirement for every finding. Freeze the Spec findings when every requirement and every changed behavior has been accounted for. Keep the pass under 400 words.

### 5. Report

Present the frozen findings under `## Standards` and `## Spec`. Preserve the separation and severity within each axis.

End with one line containing:

- the finding count for each axis;
- the worst finding within each axis, when present.

Do not choose one winner across the two axes.

## Why two axes

A change can pass one axis and fail the other:

- code that follows every standard but implements the wrong behavior passes Standards and fails Spec;
- code that implements the requested behavior but breaks repository conventions passes Spec and fails Standards.

Separate reporting keeps both failures visible.
