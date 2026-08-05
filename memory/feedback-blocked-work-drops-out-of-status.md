---
name: feedback-blocked-work-drops-out-of-status
description: Work blocked on an unmerged dependency leaves the punchlist entirely — stop reporting its state
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2b342afe-cc25-445e-9d43-423bfae3d26c
  modified: 2026-07-31T21:29:54.065Z
---

When Evan says a PR "cannot merge until X merges," that is not a sequencing note to
factor into the ordering — it means **that PR leaves the status report entirely** until
X lands. Stop rebasing it, stop polling it, stop naming its conflicts, stop mentioning
it in the punchlist. Any rework it needs is a consequence of not merging, not a task to
schedule.

**Why:** PR #968 (icon-library sweep) depended on a package change that only exists on
the `v2.3.0` release branch — it could not function without it. I kept reporting #968's
conflict state and rebasing it onto `main`, and after being told it was blocked I
answered by re-explaining its conflicts back to him. "I understand that" plus a restated
analysis is the failure: he was telling me to stop producing the analysis.

**How to apply:** on hearing a blocked-on-merge constraint, kill any running work on that
PR, drop it from every subsequent status list, and say only that it is parked pending the
named dependency. Do not re-derive or re-present its state. Resume when the blocker
merges, not before. Same discipline for any "moot until Y" signal.

Related: [[feedback-report-outcomes-not-plumbing]], [[feedback-no-method-narration-to-evan]],
[[feedback-updates-written-for-stakeholders]], [[feedback-blocked-by-is-not-a-stack]]
