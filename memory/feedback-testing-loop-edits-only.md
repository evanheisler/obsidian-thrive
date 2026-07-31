---
name: feedback-testing-loop-edits-only
description: "When Evan is testing and reporting fixes, each iteration is required edits + \"retest\" only — no preflight, test updates, commit, or push until he signs off"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1125fb31-9cef-4ad7-ac96-b42a3602015f
  modified: 2026-07-31T17:12:06.143Z
---

When Evan is in a testing feedback loop (he tests, tells you what to fix), each iteration is exactly: make the required edits → report what changed → say "retest." Nothing else — no preflight, no test updates/additions, no commit, no push. On sign-off, run the pipeline once: update tests, preflight, commit, push.

**Why:** Evan (2026-07-31) — the executor running pre-flight, updating tests, committing and pushing per iteration "burns time and CI minutes for changes that have not been approved." The loop exists to resolve an issue only he can sign off; its value is turnaround speed.

**How to apply:** Recognize the mode by its trigger — Evan tested and reported a fix ("still broken", a pasted error, "now do X"). Defer the entire ship pipeline until his sign-off, then run it exactly once. Codified in ship-issue ("Human testing feedback loop" section) and the work-project executor prompt, 2026-07-31. Related: [[feedback-design-iteration-edit-then-approval]], [[feedback-no-refire-bots-after-noop-rebase]].
