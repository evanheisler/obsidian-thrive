---
name: feedback-visual-changes-need-a-design
description: "Visual prose in a ticket (\"more prominent\", \"nicer\") is not direction — no UI styling change happens without a design; clarify before ANY work"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e16dd66b-9149-44f9-8423-a3c1008a8487
---

BH-3233 said "make the banner more prominent". I treated the title as full spec, told the executor not to park on it, and it shipped a styling change Evan rejected. His correction (2026-07-10): "You should've asked for clarification on that before starting ANY WORK. It's not direction, it's prose. We aren't changing anything without a design."

**Why:** adjectives about visual weight are not a spec. On this team, UI styling changes require an actual design (Figma) first — interpreting prose into styling is scope invention no matter how modest the change.

**How to apply:** at dispatch/triage time, split tickets into behavioral scope (buildable from prose) and visual scope. Behavioral parts proceed; any visual-styling part with no linked design gets clarified with Evan BEFORE work starts, or parked `needs-info` asking for the design. Never instruct an executor that a visual adjective is "unambiguous". Related: [[feedback-shared-primitives-need-approval]], [[feedback-resolve-framing-dont-confirm-it]] (this is a genuine fork — asking is correct here).
