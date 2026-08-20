---
name: feedback-review-means-the-full-diff
description: "\"Review the PR\" covers every file in the diff; reviewing a judged-relevant subset and reporting it as the review is a scoping failure"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 93243a7a-c384-4551-bca2-527f4b31911f
  modified: 2026-08-20T18:53:28.715Z
---

2026-08-20 (Agent OS migration): asked to review what was pushed, I reviewed only PR #1's
`os/config/` pages (the part I judged decision-relevant) and presented that as the review.
~40 files / most of the 5,800-line diff had no pass. Evan: "PR 1 was almost SIX THOUSAND
LINES and you never even reviewed it?"

**Why:** A review's unit is the PR's whole diff — same principle as
[[feedback-audit-covers-the-prs-artifacts]] and [[feedback-answer-covers-question-asked]].
Choosing a subset silently converts "reviewed" into "spot-checked", and the report inherits
the stronger word.

**How to apply:** When Evan asks for review of a PR/branch, cover every changed file (dispatch
parallel reviewers for big diffs). If only a subset got depth, say exactly which files got
what treatment — never present a partial pass with the word "review" unqualified.
