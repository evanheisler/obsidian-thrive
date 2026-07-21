---
name: feedback-review-current-head-not-bot-comment
description: "Always review the current head SHA from source; a repo bot's prior review comment can be stale and is never ground truth"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ca9d17b0-cf0a-4576-8a9e-b10920ce9c36
  modified: 2026-07-21T20:29:22.374Z
---

Reviewing the latest code from source is baseline, not optional. A repo's automated reviewer (e.g. the `claude` GitHub-Actions bot on bionic-health-app) may have commented on an earlier revision — its findings can already be fixed at head. Never treat a bot's prior review as current state.

**Why:** on PR #2168 the bot flagged webhook-freshness and geocoding-distinction gaps that were already implemented at head `1831241c2`. Trusting it would have re-raised addressed findings.

**How to apply:** pin the review to the current head SHA, read the changed files from that revision, and cross-check any prior review (bot or human) against the actual head before repeating or skipping a finding. Related: [[feedback-refetch-before-asserting-state]], [[work-project-verify-bot-reviews-yourself]].
