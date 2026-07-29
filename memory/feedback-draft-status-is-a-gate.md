---
name: feedback-draft-status-is-a-gate
description: "re-verify isDraft before any autonomous PR handling; Evan un-drafts loop PRs himself, flipping them from autonomous to approval-gated"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-29T22:13:29.146Z
---

A work-project draft PR is autonomous (fix/push/reply/resolve without asking); an un-drafted PR is approval-gated. **Evan un-drafts loop PRs himself, mid-loop** (he did it to both #911 and #914 in the DEXA work). So `isDraft` is a live gate boundary that flips under you.

**Why:** treating an un-drafted, team-review PR as a draft made me autonomously commit+push+reply+resolve on #914 after Evan had un-drafted it — crossing the approval gate.

**How to apply:** before dispatching ANY autonomous publish-handling (commit/push/reply/resolve) on a loop PR, re-fetch `isDraft` THIS turn. `isDraft:false` → approval-gated: fixes stay local, present the diff + replies for approval. Never carry a stale "it's a draft" assumption into a dispatch. Extends [[refetch-before-asserting-state]] and the [[work-project]] human-gate model (un-draft is a human gate).

**The gate covers new decisions, not steps Evan already directed (2026-07-29).** I found #961
un-drafted and stopped to ask permission for the rebase + retarget-to-`main` that *was itself the
work he had just ordered* — "obviously you fucking retard. That is a prerequisite to proving this
split even works." An un-draft does not revoke a live instruction; it gates work I would be
choosing on my own. If the action is a named step of the current directive, do it and report.
Same shape as [[feedback-gate-covers-publication-not-ci-fixups]] and
[[feedback-answer-covers-question-asked]].
