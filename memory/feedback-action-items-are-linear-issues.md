---
name: feedback-action-items-are-linear-issues
description: "Things that have to be done are Linear issues; docs are reference material — never park a required step in a runbook, PR body, or chat"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1fbc0aee-e6be-4ab1-8c5f-940e66c9159f
  modified: 2026-08-17T22:02:14.955Z
---

2026-08-17, releases-as-deploy-artifacts: the one-time cut-over step (cut the first patient
patch release right after the Release-flow PR merges, or prod JS has no deploy path) lived only
in a session message, and my proposed fix was a "Cut-over" section in the runbook. Evan: "Use
the fucking issues in linear for THINGS THAT HAVE TO BE DONE… Documentation is REFERENCE
MATERIAL. Why the fuck would you use it for project management." Resolution: BH-3897, in the
project, `ready-for-human`, blocked-by the slice that creates the need.

**Why:** A doc describes how things work whenever someone consults it; nobody re-reads docs to
discover pending work, so a step recorded there silently never happens. An issue is the only
artifact with state, an owner, and a blocked-by graph. Related:
[[feedback-stated-consequence-is-a-work-item]], [[feedback-deliverables-land-where-user-works]].

**How to apply:** The moment a plan produces a "must happen once, later" step — cut-overs,
migrations, post-merge actions, manual verifications — it becomes a Linear issue in the project
with the right label and blocked-by link (get approval per the loop's issue-authoring gate).
Runbooks keep only the repeatable procedure; PR text keeps only what reviewers need about the
diff.
