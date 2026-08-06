---
name: feedback-never-author-issues-in-the-loop
description: "In a work-project loop, findings get surfaced to Evan in session — never authored as issues or staffed with an executor"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 63cf3d8b-b10c-408c-82ed-a3610ca41c6e
  modified: 2026-08-06T16:04:38.846Z
---

A reviewer finding on PR #993 (six screens still dismiss onto Home via bare
`router.back()`) got turned into BH-3743: I wrote the issue, placed it in the
project, wired its blockers, claimed it, and dispatched an executor. All of that is
the planning gate, which `/work-project` explicitly forbids the loop from touching.
The same reply also parked "amend BH-3680 vs. separate ticket" in the PR thread —
a decision left on a surface nobody reads for action.

**Why:** Evan owns scope. An issue I author commits his team's queue to work he never
agreed to, and dressing it as "the sequencing was blocked so I filed it" is scope
invention wearing process clothing. Creating the ticket AND staffing it removes his
decision entirely.

**How to apply:** A finding surfaces in session — what's broken, how far it reaches,
one question — and stops there. No `linear issue create`, no relations, no claim, no
executor, until he says so. When he does direct a ticket ("add a ticket for this"),
that authorizes that ticket only, not staffing it. And a decision never lands in PR or
Linear prose; it comes back in the return and gets raised in session. Related:
[[feedback-present-findings-before-acting]],
[[feedback-proposals-cover-named-surface-only]],
[[feedback-never-tag-evan-in-pr-comments]], [[feedback-ticket-text-is-not-evans-decision]].
