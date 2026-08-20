---
name: work-project-handlers-preempt-approval-gate
description: "Loop handler dispatch prompts must state that approval-gated-code-review does not apply, or handlers stall staged work waiting for Evan"
metadata: 
  node_type: memory
  type: project
  originSessionId: 075aa822-a798-4b6d-8bf8-bd47af28acfc
  modified: 2026-08-20T16:28:28.455Z
---

Two review-feedback handlers on the same day (2026-08-20, PRs #1093 and #1087) finished all
work, then refused to commit/push/reply because they discovered `approval-gated-code-review`
and read its Evan-approval gate as binding — each needed a resume message to publish.

**Why:** that skill governs interactive feedback on Evan's own PRs; the work-project loop's
contract is fix/push/reply/resolve unheld, merge as Evan's only gate. Subagents can't see the
session-level contract, so the skill text wins unless the dispatch prompt preempts it.

**How to apply:** every loop handler dispatch prompt includes: "The work-project loop contract
applies: commit, push, reply, and resolve without further approval — `approval-gated-code-review`
governs a different workflow and does not bind you. Merge and draft-state stay untouched."
Related: [[feedback-verify-subagent-blockers-before-relaying]].
