---
name: feedback-read-full-pr-feedback-every-cycle
description: "in the work-project loop, read every open PR's FULL feedback each cycle (all threads incl resolved + review bodies + approvals-with-nits), not a shallow unresolved-thread count"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 9173d154-fc85-4150-b323-25665fcdc9e9
  modified: 2026-07-22T20:22:53.857Z
---

In the `work-project` loop, "monitor all PRs" means reading the **full feedback** on every open PR every cycle — all review threads (resolved AND unresolved, full comment text), every review body, and approval reviews that carry optional-but-legit nits — NOT a shallow unresolved-thread count. A PR being **approved or un-drafted does NOT mean no actionable feedback**: teammates approve *with* improvement suggestions, bots post after the fact, and review lands continuously/async. Dismissing a PR as "done/addressed" from a thread count misses real improvements.

**Why:** Evan flagged this TWICE in one run — #901's slot-test nit and #903's credential-form props improvement (`autoCapitalize="none"`/`autoCorrect={false}`) — both landed on approved/un-drafted PRs, and I skipped them by reading thread counts instead of the actual comment content. "Are you ignoring PRs that are approved instead of reading the feedback?"

**How to apply:** each cycle, for every open project PR, fetch: `reviews` (state + body), `reviewThreads` (resolved + unresolved, full comments), and issue comments — then dispatch a fix-subagent for any legit finding, including on approved PRs. Re-poll frequently; teammate/bot review is async and the harness won't notify you. Related: [[work-project-verify-bot-reviews-yourself]].
