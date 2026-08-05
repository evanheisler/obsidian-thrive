---
name: feedback-conventions-before-machinery
description: "v1 of a team workflow ships documented conventions, not enforcement scripts/CI guards — humans catch edge cases"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 27fe36a4-04d9-4189-9b61-f6e0d736e04c
  modified: 2026-08-05T18:52:48.704Z
---

Planning the Claude Design workflow (2026-08-05), I layered guard machinery into v1: a CI
path-fence + branch-protection change, an ownership-flip detection script, a staleness-compare
script — each with unit tests. Evan rejected the tier wholesale: "this whole framework is so
fucking brittle and annoying to work with… If anything like this comes up, humans can figure it
out in a second. You want to burn CI minutes and script everything to death."

**Why:** Process edge cases in a small-team workflow (a designer re-running a handoff over an
engineer's commits, a stale design-system sync) are rare, visible, and trivially resolved by the
humans in the loop. Mechanical enforcement of them is standing complexity that must be built,
tested, and maintained — it costs more than the harm it prevents. Related: [[feedback-fix-must-pay-for-itself]],
[[feedback-no-single-use-abstractions]].

**How to apply:** When designing team process/workflow tooling, v1 = documented conventions +
existing gates (review requirement, the skill's own instructions). Add a script/CI guard only
after the failure it prevents has actually occurred, recurs, and demonstrably outruns human
correction. Rules live in docs; enforcement lives in reviewers. Don't propose branch-protection
or new required checks for non-nuclear PRs.
