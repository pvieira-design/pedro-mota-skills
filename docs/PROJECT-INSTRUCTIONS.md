# AGENTS.md and CLAUDE.md

## One shared source

Use root `AGENTS.md` as the cross-agent project instruction file. Codex reads it directly. Claude Code reads root `CLAUDE.md`, so bridge the shared file:

```markdown
@AGENTS.md

## Claude Code

<!-- Only Claude-specific additions belong here. -->
```

Claude Code officially recommends importing `AGENTS.md` this way when a repository supports multiple coding agents. A symlink also works, but the import is portable and leaves room for Claude-specific instructions.

## Put each kind of knowledge in the right place

| Content | Location | Why |
| --- | --- | --- |
| Commands, architecture map, mandatory project rules | `AGENTS.md` | Needed in every coding session |
| Claude-only behavior | `CLAUDE.md` below `@AGENTS.md` | Avoids polluting other agents |
| Repeatable multi-step procedure | Skill | Loaded only when used; easier to test/version |
| Current feature behavior and code paths | `docs/system/feature-*.md` | Living technical source of truth |
| Domain vocabulary | `CONTEXT.md` | One canonical language |
| Hard-to-reverse rationale | `docs/adr/` | Durable “why” |
| Approved future work | `docs/plans/` | Executable contract, not current state |
| Deferred loose end | `docs/pending/` | Does not disappear |
| Non-obvious recurring trap | `docs/learnings/` | Prevents repeated mistakes |
| Standalone grilling Q&A | `docs/grills/` | Auxiliary session trail only |

## Keep startup instructions effective

- Prefer concrete, verifiable rules over vague advice.
- Keep the root file structured and reasonably short; link to detailed procedures.
- Do not duplicate the same paragraphs in `AGENTS.md` and `CLAUDE.md`.
- Do not store feature state in a root instruction file; link to `docs/system/`.
- Do not store a long workflow only in a skill; keep a short mandatory summary in `AGENTS.md` and the full manual in `docs/agents/engineering-workflow.md`.
- Check for contradictory nested instruction files in monorepos.
- Treat instructions as guidance, not a security boundary; use permissions/hooks for guarantees.

Official Claude reference: [How Claude remembers your project](https://code.claude.com/docs/en/memory).

## Minimum shared blocks

An installed project should make these points obvious in `AGENTS.md`:

1. project stack, structure and verification commands;
2. `docs/` artifact roles;
3. the hard grounding gate before grilling, Wayfinder or code;
4. standalone grills vs Wayfinder tracker trail;
5. approved plan → tickets → one issue per implementation session;
6. `sync-doc`, `to-plan done`, pending and learning closure rules;
7. concurrency, commit and push policy;
8. tracker and label docs under `docs/agents/`.

## Migration from duplicated root files

If `AGENTS.md` and `CLAUDE.md` are identical:

1. keep the complete shared content in `AGENTS.md`;
2. replace the duplicated `CLAUDE.md` body with `@AGENTS.md`;
3. append only real Claude-specific instructions;
4. run Claude Code `/memory` to confirm both are loading as intended;
5. start a Codex session and confirm the repository instructions are present.

Preserve unrelated user-authored content during migration.
