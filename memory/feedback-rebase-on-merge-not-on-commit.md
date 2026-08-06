---
name: feedback-rebase-on-merge-not-on-commit
description: "Cascade a stack's rebase only after the parent PR merges — never on every new parent commit"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 63cf3d8b-b10c-408c-82ed-a3610ca41c6e
  modified: 2026-08-06T19:45:33.280Z
---

During BH-3678 review I re-cascaded #994 → #996 → #998 after each new commit on #992 —
three rebases, three force-pushes, three full CI rounds, twice in a row, while #992 was
still under review and taking more commits.

**Why:** a parent under review keeps moving. Every intermediate rebase is thrown away by
the next one, and each burns CI minutes and review-noise on PRs nobody is looking at yet.
The stack only has to be correct at the moment the parent actually lands.

**How to apply:** the trigger for a cascade is the parent PR **merging**, not the parent
gaining a commit. While a parent is in review, let descendants sit stale; note that they
are stale if reporting status. This narrows `work-project`'s step-6 rule, which reads as
"keep open stacks rebased" — the intent is "don't let a merged parent strand its
children", not "track every review commit". Related:
[[feedback-no-refire-bots-after-noop-rebase]], [[feedback-stabilize-first-no-churn]].
