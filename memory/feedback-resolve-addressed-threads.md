---
name: resolve-addressed-threads
description: Review threads I actually fixed get replied to AND resolved; only untouched/informational threads stay open for the human
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

Evan (2026-07-17): "Respond to and resolve the review feedback you addressed." — reversing the earlier blanket never-resolve-threads rule for the addressed case.

**Why:** An open thread signals outstanding work. Once the fix is pushed and the reply cites the commit, leaving the thread open makes the reviewer re-triage finished items.

**How to apply:** After fix + push + in-thread reply citing the sha, resolve that thread (GraphQL `resolveReviewThread`). Threads NOT actioned — informational flags, rejected suggestions, sign-off notes — stay unresolved for the human. Related: [[feedback-gate-covers-publication-not-ci-fixups]].

This memory OVERRIDES the "never resolve a thread — the human resolves at merge" lines in the ship-issue and approval-gated-code-review skill texts (re-confirmed 2026-07-20 after I followed the skill instead of this memory and Evan had to repeat the instruction). A deliberate-no-change reply with reasoning counts as addressed once Evan has approved the reply — resolve it too.
