---
name: feedback-blocked-by-is-not-a-stack
description: "stack PRs only for a real CODE dependency; a disjoint-file Blocked-by chain branches off main with a merge-order note, not a git stack"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1835a6ad-ab07-4c6c-9342-03bd24a8d594
  modified: 2026-07-23T19:12:26.719Z
---

In a work-project run I stacked BH-3536/3537 (#915/#916) on the anchor BH-3535 (#912) purely because they were marked `Blocked by` it. Evan: "Why are 915 and 916 stacked?" — the batches touched files completely disjoint from the anchor (and each other), so there was zero code dependency; the stack only bought a post-merge `--onto` rebase cost (which then hit a real conflict with an unrelated main merge, #909).

**Why:** `Blocked by` can be a *logical/merge-order* dependency (e.g. "document the pattern before moving hooks") rather than a *code* dependency. The work-project loop's "stack a Blocked-by child on its unmerged parent's branch" rule is only correct when the child actually builds on the parent's CODE (shared/overlapping files).

**How to apply:** before stacking a `Blocked by` child, check whether it edits any file the parent also edits (or imports the parent's new code). If disjoint → branch off `main` and add a one-line "merge after #<parent>" deploy-order note instead of a git stack. Reserve stacking for true code-dependency chains. Relates to [[feedback-no-refire-bots-after-noop-rebase]] and the work-project stack-maintenance step.
