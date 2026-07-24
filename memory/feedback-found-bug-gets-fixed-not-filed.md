---
name: feedback-found-bug-gets-fixed-not-filed
description: "A defect surfaced while working a PR gets fixed in that PR, not filed as a follow-up; a ticket's must-not-change list bounds scope creep, it never preserves a bug"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7ce61522-253e-4e0a-b5af-a76e5538c616
  modified: 2026-07-24T20:22:46.860Z
---

A defect I surface while working a PR gets **fixed in that PR**. "File it as a follow-up"
is not a neutral option — Evan reads it as ignoring a known bug. A ticket's *must not
change* list exists to stop scope creep; it never authorizes shipping a defect. Deviate
from it deliberately and call the deviation out in the PR body.

Two things to check before treating a defect as a finding at all:

1. **Rebase onto fresh `origin/main` first.** On PR #917 I "found" a dark-on-brand-green
   checkmark, computed contrast ratios, and argued about scoping it — the fix had already
   merged that morning in `28b19103` (BH-3499). I was reading a stale branch. Extends
   [[feedback-worktree-base-must-be-fresh-origin]] past branch creation: re-check against
   current main before declaring a bug or a merge conflict.
2. **Find how the codebase already styles that role** ([[feedback-role-first-before-design-gap]]).
   I concluded no token cleared 3:1 on both brands and proposed a ticket, while
   `button`/`chip`/`checkbox`/`avatar` all pair `foreground-inverted` with a brand fill.

**Why:** deferring a found bug protects my diff, not the product; and contrast math on the
wrong two candidates, off a stale base, looks like research while skipping the actual research.

**How to apply:** found a defect mid-task → fix it in the same change. Reaching for
"follow-up ticket", "pre-existing", or "outside the ticket's scope" is the tell that I am
protecting the diff — do the research first, then fix. Related:
[[feedback-dont-dodge-endstate-to-avoid-churn]], [[feedback-dups-are-followups-not-rewrites]]
(which is narrower: it bars refactoring *out from under* an open PR, not fixing a bug in one).
