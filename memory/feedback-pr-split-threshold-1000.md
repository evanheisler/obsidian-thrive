---
name: feedback-pr-split-threshold-1000
description: "Evan's PR-split threshold is ~1000 lines; a coherent slice stays one PR — never relay a skill heuristic's split prompt to him"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1fbc0aee-e6be-4ab1-8c5f-940e66c9159f
  modified: 2026-08-17T21:54:11.702Z
---

2026-08-17, releases-as-deploy-artifacts: I asked Evan whether a 750-line slice PR (#1076)
should split, citing `write-pr`'s ">500 LOC → surface to the user" step. He: "I HAVE EXPLICITLY
said to consider at 1000 lines… it's one fucking PR." Then declined editing the skill: the rule
had never fired before and wasn't worth a change.

**Why:** His unit of review is the coherent slice, not a line count. A skill's advisory
heuristic is addressed to the agent composing the PR, not a question to escalate — relaying it
verbatim reads as me not owning the judgment. Related: [[feedback-conventions-before-machinery]],
[[feedback-answer-covers-question-asked]].

**How to apply:** Under ~1000 changed lines, a self-contained slice ships as one PR with no
split question to anyone. Above that, split only if the diff actually contains separable
concerns — and decide it at build time, not as a question after the PR is green. Executor
returns that flag a split heuristic get absorbed, not relayed.
