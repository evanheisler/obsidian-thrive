# Vault kernel

This vault is a context brain in the Claude OS (see the `claude-os` repo). Claude maintains it;
the human curates and directs. It compounds experience across sessions — answers come from the
wiki, not recomputation.

## Layers

```
sources/    immutable external ingests (rare) — YYYY-MM-DD-<slug>.md, never edited
wiki/       compounded knowledge (flat; concepts, entities, patterns)
os/         how the agent operates here: skills.md registry, workflows/, config/
index.md    navigation map over wiki/ and os/ — update whenever a page is added
log.md      append-only session record — ground truth for every wiki claim
memory/     Claude Code auto-memory (thin pointers into os/ and wiki/)
```

## Boot

Session context is injected by the Claude OS SessionStart hook. Additionally read any
`os/workflows/` page matching the task **before acting**; if none fits, do the work, then write
the workflow at session close.

## Provenance

Every wiki claim cites its ground truth inline: `log: YYYY-MM-DD` (experience — the normal
case) or `source: YYYY-MM-DD-slug` (external material). Claims with neither are lint
failures. Never invent knowledge without backing.

Citations are **inline code, never wikilinks** — a `[[log: ...]]` link has no target page and
mints a permanent ghost node in Obsidian's graph. Exclude `log.md` and `memory/` from the
Obsidian viewport via `.obsidian/app.json` `userIgnoreFilters`.

When a date holds multiple log entries, disambiguate with the entry title:
`log: YYYY-MM-DD — <entry title>`.

## Wiki schema

Flat `wiki/`, lowercase kebab-case names. Frontmatter:

```yaml
---
title: Human-Readable Title
summary: one-line description
type: concept | entity | synthesis
last_updated: YYYY-MM-DD
---
```

Every page links to ≥1 other wiki page via `[[wikilink]]`. Cross-link bidirectionally where
meaningful.

## Log schema

Append-only; one entry per session at the bottom:

```markdown
## YYYY-MM-DD — <short session title>
repo: <where the work happened: this vault | org/repo>

- What was done / decided
- Wiki/os pages touched: [[page-a]], [[page-b]]
- Learnings: <distilled> | none
```

`Learnings:` is mandatory. A learning must land in `wiki/` (knowledge) or `os/` (behavior)
in the same session — `/lint` audits `none` entries against the session's content.

## Session close (mandatory)

Every session that touches this context ends with `/session-close`: log entry → distillation
gate → index update → structural lint → commit + push. A commit guard blocks vault commits
without a pending `log.md` change.

## Maintenance

- Auto-commit and auto-push vault changes every session; own it — never ask for review.
- External publishes (issues, posts, purchases) require explicit approval; vault commits don't.
- Run `/lint` weekly.
