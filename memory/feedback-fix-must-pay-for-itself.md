---
name: feedback-fix-must-pay-for-itself
description: A mechanically correct fix still has to beat the harm it removes — price it before recommending
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 468486d0-126b-4cb6-88da-14a9cd081218
  modified: 2026-08-05T16:16:13.737Z
---

Twice in one session I recommended the technically-correct repair without weighing it
against the damage it actually removes:

- BH-3721: proposed patching the vendor filter's stretch + orientation math, when a
  cover-cropped 16:9 asset still reads wrong in a portrait frame — the fix wouldn't have
  fixed the user-visible problem. Evan: "Why would we layer a patch over this?"
- The fingerprint baseline gap: proposed doubling a 2m57s check on every patient PR to
  remove a cosmetic label on release-branch PRs. Evan: "Not worth it."

**Why:** correctness of the mechanism is not the bar. The bar is whether the fix buys
more than it costs — and a defect that is cosmetic, or one whose repair leaves the
symptom in place, often loses that trade.

**How to apply:** before recommending a fix, state what breaks without it and who
notices, then the fix's recurring cost. If the harm is cosmetic, or the fix leaves the
reported symptom standing, lead with descope / accept-and-document instead. Put the
price in the recommendation, not in a risks footnote after it.

Related: [[thrive-fingerprint-release-branch-false-positive]],
[[thrive-node-modules-cache-no-payoff]], [[feedback-present-findings-before-acting]]
