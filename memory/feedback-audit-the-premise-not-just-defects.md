---
name: feedback-audit-the-premise-not-just-defects
description: "When returned work introduces a mechanism the ticket didn't ask for, surface the design choice to Evan before iterating on it — bug-fixing a bad premise ratchets it in"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cfb1c4e0-469f-49af-aeab-0d04bd3200bd
  modified: 2026-08-10T19:27:23.815Z
---

BH-3680 (#996, 2026-08-10): a rework agent replaced a five-line declared per-tab route map
with runtime derivation from navigator state. I audited each iteration for *defects* — found
and fixed three (focus walk, key match, cold start) — but never put the *premise* to Evan.
Worse, I laundered the agent's choice into a settled decision ("reverting to the provider is
a reversal of a decision you already made"). Justin's review said the abstraction was
speculative; I relayed it and kept building. Evan: "Why did you let it get to this point?
It never should've been written this way and you failed to flag a bad design choice."

**Why:** each fix round was locally justified, so complexity ratcheted — three broken
iterations, a real-navigator test harness, and a global mock, all to avoid one declared map
per tab. The audits caught every bug and missed the only question that mattered.

**How to apply:** when a subagent's return introduces a mechanism, abstraction, or dependency
that the ticket didn't specify — especially one replacing something simpler — that is a
design decision, not an implementation detail: present simple-vs-clever to Evan before any
fix/iteration lands on top of it. A reviewer saying "this abstraction is speculative" is that
same fork re-opened, not a finding to relay. Test: would deleting the mechanism and doing it
the dumb way shrink the diff? Then the mechanism needs Evan's explicit yes. Related:
[[feedback-fix-must-pay-for-itself]], [[feedback-no-single-use-abstractions]],
[[feedback-shared-primitives-need-approval]], [[feedback-present-findings-before-acting]].
