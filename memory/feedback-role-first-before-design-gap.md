---
name: role-first-before-design-gap
description: "A site is only a design gap if its ROLE matches no slot — pixel mismatch with every slot is not a gap, it's a snap-by-role"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

Evan (2026-07-16), on 8 "design call" font-display sites: "Are these legitimate design gaps or your typical 'Right now its 26px but the design is 24px, I don't know what to do!'" — 5 of 8 were section headings whose role names the slot; only 3 role-less numerals were real gaps.

**Why:** The lockstep doctrine picks slots by ROLE; the visible size/family change from snapping is the deliverable, not a blocker. Labeling every pixel mismatch a design call floods Evan with fake decisions and stalls slices.

**How to apply:** Before escalating any site as a design gap, ask "what is this element's role?" (heading level by hierarchy, body, label, button, numeral). Role → slot exists → snap it (visible change intended). Only when the role itself has no slot (e.g. stat/price numerals in the display face) is it a design call. Applies doubly when a slice's own invariant (Thrive-must-not-move) blocked a snap — the successor slice without that invariant inherits it as work, not as a question.
