---
name: feedback-pin-executors-to-opus
description: "Every executor/review-handler subagent dispatch is pinned to Opus (model \"opus\"), even when orchestrating outside work-project"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 93243a7a-c384-4551-bca2-527f4b31911f
  modified: 2026-08-20T17:02:36.589Z
---

Dispatching executors without `model: "opus"` let them inherit the session model (2026-08-20,
Agent OS migration — five executors ran unpinned). The pin rule lives in work-project
(SKILL.md:151, 205, 425); hand-rolling orchestration around ship-issue dropped it.

**Why:** Evan pins executor cost/behavior deliberately ("Opus Medium"); the orchestrator's
dispatch rules apply to any hand-rolled dispatch loop, not just when work-project itself runs.

**How to apply:** Any Agent dispatch that executes an issue, handles a review, or does
executor-shaped work gets `model: "opus"` — including ad-hoc orchestration when work-project
is unusable. When bypassing a prescribed orchestrator, port its dispatch rules into the
hand-rolled loop first ([[feedback-run-prescribed-skills-not-handrolled]]).
