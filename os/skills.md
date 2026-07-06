---
title: Skill Registry
summary: Every skill available in this context — trigger, scope, what it does
last_updated: 2026-07-06
---

# Skill Registry

| Skill | Scope | Use when |
|---|---|---|
| `/session-close` | claude-os | Ending any session — log, distill, commit, push |
| `/capture` | claude-os | Ingesting external material into `sources/` + wiki |
| `/lint` | claude-os | Weekly vault + OS health check |
| `/vault-smoke-test` | this vault | First-startup pipeline check — delete after verified |

Add context-specific skills (this vault's `.claude/skills/`) below as they're created.
New context-specific skills go through `superpowers:writing-skills` (TDD baseline before
deploy); the smoke-test canary is exempt as a pure pipeline check.
