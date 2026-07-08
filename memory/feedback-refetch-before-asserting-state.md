---
name: refetch-before-asserting-state
description: "Re-fetch live state (PR bodies, comments, CI, files) before asserting it — conversation context goes stale the moment Evan acts in parallel"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3386b40e-8536-4fec-a976-2be83175ac1a
---

I told Evan the PR's Screenshots section was "still empty" based on the draft I wrote earlier in the session; he had already replaced it with an attachment. Same session also produced the "github-actions comment is the review" mistake. Both were assertions about external state from stale context.

**Why:** Evan works in parallel (labels, PR edits, simulator runs). Anything I didn't just read is a hypothesis, not a fact, and stating hypotheses as facts costs trust far more than one extra `gh` call costs time.

**How to apply:** Before any sentence of the form "X is still…", "X hasn't…", "there is no…", about a PR, issue, CI run, or file I didn't modify this turn — fetch it first. If fetching isn't worth it, phrase it as unverified ("as of my last look"). Related: [[cross-check-measurements]].
