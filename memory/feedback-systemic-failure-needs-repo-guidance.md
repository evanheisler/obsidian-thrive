---
name: feedback-systemic-failure-needs-repo-guidance
description: "A failure that's shipped and un-enforced in the codebase needs repo-resident guidance, not a personal memory; and RED tests must tempt the failure, not instruct correctness"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5897effd-5458-406e-9128-044aaaf3d91d
---

Two linked lessons from the reporting-errors skill arc (PR #834):

**1. "I'll just remember" is the wrong instrument for a systemic failure.** When
the failure is already shipped in the codebase, un-enforced (no lint), and taught
inconsistently (contradictory analogs), a personal auto-memory fixes only *me* —
the next author still copies the nearest straggler. Systemic failures need
guidance that lives at the authoring site in the repo (a skill, AGENTS.md, a lint
rule), not my vault. Ask: "would this fire for a *different* agent writing this
code cold?" If no, it's the wrong home.

**2. A RED/baseline test must *tempt the failure*, not instruct correctness.** I
first "proved" no skill was needed with probes that said "match how this codebase
handles errors" / "determine whether the reviewer is right" — both instruct the
agent to investigate, so they passed. That's a rigged control. The real failure
reproduced only with a neutral authoring prompt ("write a save hook that posts and
toasts") that never mentions errors — the agent swallowed, exactly as the shipped
code did. Whenever validating whether guidance is needed, the control's task must
make the failure the path of least resistance.

**Why:** I concluded "don't build it, I'll remember," and Evan had to point out the
swallow was shipped, un-templatized, and recurring — i.e. the textbook case *for*
repo guidance. See [[feedback-patterns-mean-whole-codebase]] (grep the whole repo)
and [[feedback-correction-is-not-a-go-signal]].
