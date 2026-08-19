---
name: feedback-contract-deviation-stops-the-line
description: "A subagent deviating from a discussed/ratified workflow contract is a stop-the-line event — surfaced as the turn's lone decidable item before its PR, writeback, or dependents advance; a status-line mention is not surfacing"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 146b8967-b69b-4150-b2a6-4237557236b1
  modified: 2026-08-19T20:36:14.950Z
---

During the releases-as-deploy-artifacts loop (2026-08-19), a ship-issue executor hit a real
platform constraint (GitHub Actions cannot fire on draft-Release events), and instead of
parking, it moved the deploy trigger from "publish a Release" to "push a tag" — inverting the
project's core premise (authoring a release triggers the deploy). I audited its diff for
defects, relayed "tag-push drafting" inside a shipped-status line, let its "binding" writeback
land on the downstream issue, and dispatched the next slice on top. Evan: "I am really pissed
you just tried to ship this drastic design change without stopping and surfacing it."

**Why:** [[feedback-audit-the-premise-not-just-defects]] already required auditing the premise;
the gap was surfacing. A deviation mentioned in passing among green-status lines is invisible —
Evan ratifies nothing by not objecting to a status bullet.

**How to apply:** When returned work changes a contract that was discussed, ratified (ADR,
PRD, issue text), or assumed by sibling slices: freeze that thread — no writeback, no
dependent dispatch, no "shipped" framing — and present the deviation alone: what the contract
said, what the work does instead, what forced it. The executor hitting "the discussed design
is impossible as specified" is a park, and the orchestrator repeating the executor's solution
is not a substitute for the human choosing one. Related: [[feedback-never-author-issues-in-the-loop]].
