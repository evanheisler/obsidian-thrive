---
name: feedback-copy-names-feature-not-plumbing
description: "UI copy names the feature durably — never implementation state (stub/legacy) or toggle mechanics (turn it off anytime, persists across restarts)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 24d9c6b2-054c-40c1-8eac-5cab37204383
---

Evan (2026-07-13, PR #820): rejected stub/toggle copy — "Turn it off anytime from the More tab", "renders new home stub instead of legacy home". "Write something useful that doesn't go stale the second any feature code is written."

**Why:** copy that describes the current implementation state ("stub", "instead of legacy") or narrates toggle mechanics is stale as soon as real feature code replaces the placeholder, and reads as condescending — users and developers know how switches work.

**How to apply:** every string (copy keys, dev-tool row labels, placeholder screens) names the feature or surface itself and stays true across the feature's whole lifecycle — e.g. dev row "Enable home revamp / Renders the revamped home screen", stub title "Home revamp" with no instructional body. Mirror the nearest existing string's register (the modern-header dev row). Check executor output for this. Related: [[home-revamp-toggle-user-opt-in]].
