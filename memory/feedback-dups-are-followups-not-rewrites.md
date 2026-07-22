---
name: feedback-dups-are-followups-not-rewrites
description: "Duplication/cleanup found while a PR is in review is a follow-up PR after it merges — never rewrite the in-flight PR or couple it to a not-yet-merged shared-helper extraction"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-22T19:39:52.934Z
---

When a reuse/DRY problem surfaces on code that's already in an open PR under review, the fix is a **follow-up PR after that PR merges** — not a rewrite of the in-flight PR, and never coupling the open PR to a not-yet-merged shared-helper extraction ("refactoring out from under the PR"). Ship the slice on its own merits (resolve its review threads with local fixes), then dedup once its code is in main. Evan: "I did not expect you to refactor out from under the PR. If it were me I would've handled it as a follow-up."

**Why:** rebasing an open PR onto an in-flight refactor makes it depend on unmerged work, churns its diff mid-review, and stalls a slice that was ready to land. The extraction and the slice are independent — keep them so.

**How to apply:** dups found mid-review → (1) keep the open PR standalone, resolve its threads with local fixes, move it toward merge; (2) do the shared extraction as its own PR touching only already-merged consumers; (3) migrate the slice's copy in a later follow-up once it's merged. Don't stack the slice on the refactor. Relates to [[feedback-reuse-existing-system-prove-divergence]], [[feedback-stabilize-first-no-churn]].
