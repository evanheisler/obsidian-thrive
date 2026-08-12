---
name: feedback-plain-steps-not-abstractions
description: Explain designs as numbered concrete steps a person can picture; abstraction vocabulary reads as hand-waving to Evan
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 95b14bfb-8cac-4532-b296-ebd5765b8dbc
  modified: 2026-08-12T18:33:20.692Z
---

Across the BH-3726 crisis Evan escalated four times over language, not substance:
"Speak English", "One question at a time", "STOP WRITING SO FUCKING MUCH AND BURYING
THE DETAILS", "I HAVE NO FUCKING IDEA WHAT YOU ARE TALKING ABOUT." What finally landed
was four numbered steps ("Someone runs the sync once… we save the files… anyone uploads
them… re-run when components change"). He replied: "Those steps were always the design."

**Why:** Abstraction vocabulary — "artifact", "deterministic", "checkpoint", "stage",
"premise", "capture source" — compresses for me but is opaque to the reader and buries
the mechanics. If the design can't be said as steps a person performs, I don't
understand it yet either.

**How to apply:** Explain any workflow/design as a short numbered list of actions with
actors ("someone runs X, the files land in Y"). One idea per sentence. Use a jargon term
only after the plain sentence has said the thing. This applies to ticket text and READMEs
too, not just chat. Relates to [[feedback-mirror-users-model-verbatim]].
