---
name: feedback-no-dead-code-for-test-churn
description: "code a change orphans gets removed in that same change; test-file churn is never a reason to leave dead code, and I must vet executor scope-cuts before relaying them"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f79e8728-a303-482e-9d25-184d41d276ea
---

When a change makes existing code dead (write-only, no remaining reader), removing it — and updating every test that references it — is part of that same change. "Removing it would touch ~N test files / is beyond the named surface" is NOT a valid reason to ship the orphan. The PR that orphaned the code is the PR that deletes it.

**Why:** dead code left behind is a real defect (violates the repo's no-dead-code / DRY standard), and test churn is the ordinary cost of the change, not a scope boundary. Evan caught this when a ship-issue executor kept a now-unread `utmParams` intake-state field to avoid updating ~12 `IntakeState`-literal test files, and I relayed the executor's framing ("scope decision") neutrally instead of flagging it as a miss.

**How to apply:** (1) as an executor/author, delete code your change orphans and eat the test updates; (2) as the orchestrator, don't relay an executor's scope-cut as settled — verify it (grep for remaining readers), and treat "left it to avoid test churn" as a defect to fix, not a tradeoff to report. Relates to [[feedback-orchestrator-delegates-execution]] and [[feedback-proposals-cover-named-surface-only]] (the named-surface rule bounds *feature* scope, not cleanup of code the change itself kills).
