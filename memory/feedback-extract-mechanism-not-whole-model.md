---
name: feedback-extract-mechanism-not-whole-model
description: "A reference repo given as a datapoint supplies a mechanism to borrow, not a model to adopt wholesale"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 5ee11a26-aaa5-4be8-98b7-c75b03b26a90
---

When Evan cites another repo/system as a datapoint (e.g. bionic-health-app's tag-release strategy), extract only the specific mechanism that serves *his* stated goal — do not import that system's whole model.

**Why:** Given bionic-health-app as one datapoint for a deploy-traceability task, I adopted its entire "one version line drives every channel / forced cross-surface parity" architecture. Evan's actual goal was far narrower — per-deploy traceability, channels allowed to differ. The imported model drove the design in circles for most of a session before he tore it out ("I DON'T FUCKING WANT MORE ABSTRACTIONS ON TOP OF WHAT WE DO TODAY").

**How to apply:** Restate the user's goal in one line first. Then take from the reference only the piece that advances that goal (here: "a Release ties to a surface"). Before generalizing a borrowed pattern, check it against the goal — if it adds constraints the user didn't ask for (parity, unified versioning), drop it. Reference repos are parts bins, not blueprints. See [[feedback-dont-repave-deliberate-wiring]], [[feedback-correction-is-not-a-go-signal]].
