---
title: Karpathy's LLM Knowledge Bases
summary: The pattern this vault implements — Karpathy's actual statements, design properties, and where this vault already matches or diverges
type: concept
last_updated: 2026-08-19
---

# Karpathy's LLM Knowledge Bases

Andrej Karpathy's "LLM Knowledge Bases" X post (2026-04-03, https://x.com/karpathy/status/2039805659525644595) and follow-up gist `llm-wiki.md` (2026-04-04, https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f, 5k+ stars) describe the pattern this vault implements. Researched for the agent-os redesign `log: 2026-08-19`.

## What he actually proposed

- Direct quotes: *"The LLM writes and maintains all of the data of the wiki, I rarely touch it directly"*; the gist is *"intentionally kept a little bit abstract/vague because there are so many directions to take this in."* His own research wiki: ~100 articles / ~400K words.
- Framed explicitly **against RAG**: retrieval rediscovers knowledge from scratch on every question; a maintained wiki compounds it instead.
- **Three layers**: immutable raw sources (never modified by the LLM) → LLM-generated markdown wiki → a schema doc (CLAUDE.md / AGENTS.md) defining structure and conventions.
- **Compiler analogy**: raw = source code, LLM = compiler, wiki = compiled artifact; incremental recompilation on each ingest.
- **Three operations**: Ingest (one source updates ~10–15 related pages), Query (answer from wiki with citations; valuable analyses filed back as pages), Lint (contradictions, stale claims, orphans, missing cross-links).
- Plumbing: `index.md` catalog + append-only `log.md`. "Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase." Human role = curation and direction, not editing.

## Mapping to this vault

This vault already is the pattern: `sources/` / `wiki/` / kernel `CLAUDE.md` schema, `index.md`, `log.md`, `/capture` = Ingest, `/lint` = Lint. Divergences worth knowing:

- Karpathy's corpus is **ingest-driven**; this vault is **experience-driven** — `sources/` has zero ingests, every claim is `log:`-backed, and the corpus weight sits in `memory/` (156 files) not `wiki/` (12 pages). The vault extends his pattern with a behavioral-feedback layer he doesn't model.
- He treats the wiki as answer substrate for *queries*; this vault additionally uses `os/` as an execution substrate (workflows, skills, hooks) — see [[codex-config-surface]] for how that layer projects across agents.
