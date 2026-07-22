---
name: feedback-stabilize-first-no-churn
description: "Dependent slices sequence stabilize-first; don't pose a churn-vs-speed fork"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d2aeadc4-a3bf-468c-a3c7-78aa8e3b177a
  modified: 2026-07-21T21:59:41.114Z
---

For a chain of dependent slices/PRs (each imports the layer below), default to **stabilize-first**: dispatch slice N+1 only after N's draft PR is green through review, never the moment N commits. Evan does not want to manage unnecessary rebase churn.

When I framed eager-pipeline vs stabilize-first as a decision, Evan cut it: "You could've just said the slices are dependent and left it at that."

**Why:** The dependency already dictates the order; dressing it as a speed/churn fork manufactures a decision and adds verbosity. Churn-aversion is a standing preference, so stabilize-first is the default, not a question.

**How to apply:** When work is dependency-ordered, state the dependency in one line and proceed stabilize-first. Reserve questions for genuine forks the dependency doesn't settle.

Related: [[feedback-mechanical-sequencing-is-not-a-fork]], [[feedback-no-abbreviated-decision-prompts]], [[feedback-cap-is-agents-not-open-prs]]
