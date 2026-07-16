---
name: surface-visual-deltas-directly
description: "A reviewer-flagged visual risk on an agent PR gets surfaced to Evan concretely (screen, before → after, what could look wrong, screenshots when possible) — never answered with \"it's on the test plan\""
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 904ea139-3416-4522-ada0-9855ab61e6dc
---

When review feedback flags a possible visual regression on an agent-authored PR, pointing at the test plan or sign-off checklist is burial, not action. Evan (2026-07-16): "Adding comments like 'its in the test plan' are useless. You need to surface regressions TO ME. I am running the app now to check the issues you buried with documentation instead of action."

**Why:** Evan is the visual sign-off; the orchestrator's job is to make that check cheap. A thread reply that files the risk under documentation forces him to rediscover what to look at and where. The flagged spots are the highest-value items in the whole review cycle — they are exactly what could be wrong.

**How to apply:** For every reviewer-flagged visual delta: tell Evan directly, in the checkpoint/report — exact screen/route, before → after values, and what "wrong" would look like (clipping, too bold, misaligned). Where feasible, produce before/after screenshots (patient-screenshot / patient-screenshot-mobile skills) instead of prose. The GitHub reply can still note the technical verification, but the surfacing to Evan is the deliverable. Related: [[feedback-mock-must-show-chrome-relationships]] (executors verify visually in the running app before pushing).
