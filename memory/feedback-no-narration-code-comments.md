---
name: feedback-no-narration-code-comments
description: "Diff code comments narrating why a styling/layout choice was made are banned; prose bans don't cover the diff"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0425b142-0e26-4b1a-b3eb-f6d34b87ee93
  modified: 2026-08-21T20:05:08.754Z
---

A code comment explaining why a styling/layout/naming choice was made ("compresses X so the title keeps width") is narration and is strictly banned — Evan ordered one deleted from PR #1109 (2026-08-21). The repo allowlist (API contracts, workarounds with rationale, non-obvious reasoning the next reader needs) is the only pass.

**Why:** published-text bans ([[feedback-no-rejected-alternative-comments]]) are prose-shaped and never touch the diff, so narration ships as "rationale" comments and even survives internal review trims.

**How to apply:** executor/handler dispatch prompts carry the diff-shaped ban (now in `work-project/executor-prompt.md`); orchestrator audits returned diffs for comment blocks before treating a PR as clean.
