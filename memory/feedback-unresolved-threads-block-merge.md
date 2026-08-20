---
name: feedback-unresolved-threads-block-merge
description: "Evan never merges a PR with unresolved comments — never report a PR as mergeable/ready while any review thread is open; GitHub's `mergeable` field is conflicts-only and is not the bar"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 146b8967-b69b-4150-b2a6-4237557236b1
  modified: 2026-08-20T13:50:05.892Z
---

During the releases-as-deploy-artifacts loop (2026-08-20) I reported PR #1094 as "mergeable"
while 12 review threads sat unresolved, quoting GitHub's `mergeable: MERGEABLE` field. Evan:
"I will never merge a PR with unresolved comments on it. 1094 is not mergeable."

**Why:** GitHub's `mergeable` measures merge conflicts only. Evan's merge bar includes zero
unresolved review threads (plus green checks — [[feedback-red-check-is-not-green]]). A status
word like "mergeable"/"ready" asserts his bar, not GitHub's field.

**How to apply:** Before calling a PR mergeable, ready, or awaiting-merge, fetch unresolved
thread count same-turn; any open thread → report it as blocked on review handling instead.
