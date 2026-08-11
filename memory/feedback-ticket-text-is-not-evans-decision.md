---
name: feedback-ticket-text-is-not-evans-decision
description: "A structural instruction in a ticket body (PR count, slicing, stacking) was written by a planning agent, not decided by Evan — surface it before executing it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f81fc5bf-48a6-4b30-b4a1-27f125a75f47
  modified: 2026-08-11T20:19:59.984Z
---

Linear ticket bodies in this workspace are largely **agent-authored during `/plan-project`**.
A directive inside one ("ship in this order, **one PR each**", "split into N slices", "stack on
X") is therefore an **agent's invention until Evan has seen it**, not a decision he made. Never
treat it as binding the way an instruction from Evan is binding.

**Why:** planning agents invent structural decisions and never surface them, so they reach
execution unchallenged and contradict what Evan actually wants. Evan, 2026-07-29, on BH-3538
shipping as four stacked PRs totalling 9 files / +266−104: *"That is not what I agreed to. The
PRs are all tiny… The stupid fucking agents just make shit up in the planning phase and do not
surface these decisions."*

**How to apply:** when a ticket body dictates the **shape of the deliverable** — how many PRs,
how work is sliced, what stacks on what — sanity-check it against the actual size of the diff
before dispatching. If the ticket's shape and the real scope disagree (four PRs for ~250 lines
across 9 files), that is a fork Evan owns: state the mismatch and ask, in one line, before
dispatching. Executing it silently and reporting after is the failure.

The ticket's technical content is a **starting point, not a spec** — when repo evidence
contradicts it, the code wins without escalation (see
[[feedback-issue-text-is-a-starting-point]], Evan 2026-08-11). This memory is about
deliverable shape only: shape gets surfaced *before* executing; technical lines get
overridden *by evidence* and reported.

Related: [[feedback-blocked-by-is-not-a-stack]], [[feedback-pr-descriptions-short]],
[[feedback-present-findings-before-acting]], [[feedback-mechanical-sequencing-is-not-a-fork]]
(sequencing is mine; *how many PRs Evan reviews* is not).
