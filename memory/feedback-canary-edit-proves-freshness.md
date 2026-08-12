---
name: feedback-canary-edit-proves-freshness
description: "In a device-testing loop, prove code freshness with one unmissable canary edit before iterating on subtle deltas — never with pixel forensics or server-side inspection alone"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ca360ef0-3521-4f71-8a69-b3434f7f3e70
  modified: 2026-08-12T16:51:12.597Z
---

When a testing loop's change is visually subtle (a 2px icon resize) and the human reports "no difference," the first move is a canary: an obvious, reversible edit (size 40, red tint) the human can confirm in one glance. Canary visible → pipeline fresh, revert and iterate on the real delta. Canary invisible → delivery is broken and now there's a decisive signal. Evan (2026-08-12, BH-3628): "You could've pushed an OBVIOUS EDIT to ensure the bundle was fresh instead of all this flaky and inaccurate inspection."

**Why:** server-side proof (bundle contains the edit) does not prove device-side delivery, and screenshot pixel forensics fails without a baseline and calibrated scale — three retest rounds burned on Metro/watchman/reload archaeology that one canary reload would have settled.

**How to apply:** at the first "no change" report in any edit-retest loop, apply the canary in the same component that's under test, ask for one reload, then revert it in the same turn the human confirms. Related: [[feedback-validate-the-instrument-first]], [[feedback-instrument-dont-use-evan-as-sensor]], [[metro-stale-bundle-watchman]].
