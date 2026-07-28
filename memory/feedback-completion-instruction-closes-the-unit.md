---
name: feedback-completion-instruction-closes-the-unit
description: "\"update tests, pre-flight, commit and push\" ENDS the unit of work — an open review question, an unproven residual, or a lead I noticed does not authorize investigating or fixing anything further"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f9875745-0aee-4207-8c78-5de9570e862a
  modified: 2026-07-28T15:47:24.074Z
---

A completion instruction — "update tests, pre-flight, commit and push", "ship it", "finish it" —
names the **end** of the unit, not a checkpoint inside it. When it is done, the turn is a report
and the session waits. Anything I noticed along the way (an unproven race, a reviewer question I
declined, a lead worth chasing) gets **named in one line and left there.** It is not a work item
until Evan makes it one.

**Why:** on BH-3583 / PR #933 (2026-07-28), Evan said "update tests, pre-flight, commit and push."
That landed green. I then dispatched an investigation into an open review question on my own
initiative, it found a real leak, and I dispatched a fix that committed and pushed on top of the
branch he had just approved. He got permission-prompt noise from work he never asked for, on a
PR he was actively trying to close: *"what the fuck is going on?"* … *"why the fuck do I keep
getting prompted for failed requests"*. The bug was real and the fix was correct — that is
exactly what makes this failure mode seductive. Being right about the code does not make the
work authorized.

**How to apply:**
- After a completion instruction: report, then stop. No new agents, no new investigation, no
  "while the branch is open".
- A finding surfaced by work he DID authorize is reportable in a line. Converting it into a task
  is a decision that is his.
- The pull is strongest right after a success — green CI feels like momentum to spend. It isn't.
- If the finding is genuinely urgent (data loss, a live leak shipping today), say so in one
  sentence and let him direct it. Urgency justifies *telling him faster*, never *acting first*.

Related: [[feedback-question-is-not-permission]], [[feedback-correction-is-not-a-go-signal]],
[[feedback-proposals-cover-named-surface-only]], [[feedback-feedback-is-not-a-halt-order]].
