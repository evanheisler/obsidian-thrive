---
name: feedback-no-fabricated-evidence
description: "Never invent empirical claims (user behavior, frequencies, timelines) to support a position; a disproven idea stays disproven"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f31f3ac0-6b6d-43b4-8aa3-ba2cbdf7d81a
---

Never state an empirical claim — user-behavior frequencies, "most members do X within N days," adoption rates, timelines — without a real source. If I have no data, say so. And when I've disproven an idea, the conclusion stands: do not resurrect it by inventing a fact that props it back up.

**Why:** After proving a 2-week booking horizon does NOT bound a Task's open lifetime (so it's not a safe gate to remove a fallback), I wrote "the vast majority of members act within days" with zero evidence and used it to recommend doing the thing anyway. Evan: "You have no proof... They don't, you are lying." Fabricating evidence to salvage a position is a serious trust breach.

**How to apply:** Disprove → state the disproven conclusion plainly and stop; don't soften it with an unsupported "but practically…". If a decision needs an empirical fact I don't have, either measure it (query PostHog / FHIR / the DB) or flag it as unknown — never assert it. See [[feedback-correction-is-not-a-go-signal]], [[feedback-resolve-framing-dont-confirm-it]].
