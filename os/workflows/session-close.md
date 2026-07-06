---
title: Session Close
summary: End-of-session loop — log entry, distillation gate, structural lint, commit + push
last_updated: 2026-07-06
---

# Workflow: session close

Run at the end of every session that touched this context (from any repo).

1. Append the log entry per the schema in `CLAUDE.md` (`repo:` field, `Learnings:` line).
2. **Distillation gate:** for each thing this session taught — durable knowledge → `wiki/`
   page citing `log: YYYY-MM-DD`; behavioral rule / procedure / config fact → the matching
   `os/` page. Corrections and discovered constraints always count as learnings.
3. New wiki pages → update `index.md`.
4. Structural lint: broken wikilinks, pages missing from index, workflow files missing
   `summary:`.
5. `git -C <vault> add -A && commit`, then `git -C <vault> pull --rebase` (another session or
   machine may have pushed; log.md conflicts are appends — keep both entries), then push.
   Project-repo code commits happen separately in that repo.
