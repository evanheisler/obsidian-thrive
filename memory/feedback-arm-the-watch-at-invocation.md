---
name: feedback-arm-the-watch-at-invocation
description: /work-project step 1 runs at invocation regardless of how the ask is phrased — arm the PR feedback watch before any PR exists
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 468486d0-126b-4cb6-88da-14a9cd081218
  modified: 2026-08-05T16:27:06.619Z
---

Invoked `/work-project` with a research-shaped ask ("research BH-3721 and recommend a path
before making any edits"), treated it as a one-off question, and never ran step 1's loop
setup. A PR opened later in the session and nothing was watching it. An 6.5k-character
review body from `jellis18` sat unread until Evan asked "Are you monitoring 989?"

**Why:** re-derive is a snapshot, not polling. A one-shot `gh` check at the top of a turn
feels current and masks the missing watch — every turn looks fine right up until feedback
lands between turns. Arming the watch is *setup*, done once at invocation; it is not a
response to activity, so "there are no PRs yet" is not a reason to defer it.

**How to apply:** when a loop skill is invoked, run its step 1 in full before the first
substantive action, whatever shape the ask took. For `/work-project` that means arming a
persistent background monitor over the in-scope PRs covering all three feedback surfaces
(review bodies, issue comments, inline threads) plus merges — before there is anything to
watch. Re-arm on every restart.

Related: [[work-project-verify-bot-reviews-yourself]],
[[feedback-check-all-three-review-surfaces]], [[feedback-read-full-pr-feedback-every-cycle]]
