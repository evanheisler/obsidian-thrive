---
name: feedback-stated-consequence-is-a-work-item
description: "When Evan names a consequence while approving (\"this will also break X\"), X's resolution becomes a tracked work item driven to terminal state — not an acknowledged fact"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cfb1c4e0-469f-49af-aeab-0d04bd3200bd
  modified: 2026-08-10T22:07:16.236Z
---

Closing #996, Evan approved with: "This is will also break the stack that exists today."
I handled the mechanical half (gh stack unstack) and let the substantive half — stacked
child #998's disposition — sit as a "still awaiting your call" status line for three days
while its base was force-pushed out of existence and its mechanism superseded twice. Evan,
on finding it: "what the fuck is the deal with 998?! … So this is the stranded stack I
warned you about when closing 996? Yeah you dropped the ball on being the orchestrator here."

**Why:** a consequence named at approval time is Evan delegating its handling, not adding
color. Parking the resulting decision behind other asks let the artifact rot until he hit
it himself — the orchestrator's core job is driving every open artifact to a terminal
state (merged, closed, or re-cut), not keeping an accurate list of limbo.

**How to apply:** when an approval or directive names a side effect ("this breaks X",
"that'll orphan Y"), immediately convert it into a work item with a terminal state, and
re-raise its decision as the NEXT single ask — it outranks queued new work, because a
structural event (parent closed, base gone) makes the stranded artifact decay with time.
An open PR/issue whose plan is invalidated does not wait its turn in the ask queue; it IS
the most blocking item. Related: [[feedback-blocked-work-drops-out-of-status]] (which cuts
noise, but never applies to an artifact whose disposition is undecided),
[[feedback-action-items-explicit-list]].
