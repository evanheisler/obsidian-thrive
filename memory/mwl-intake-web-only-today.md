---
name: mwl-intake-web-only-today
description: The MWL intake funnel is not used on native today — native-only intake defects are low-stakes interim risks
metadata: 
  node_type: memory
  type: project
  originSessionId: ca360ef0-3521-4f71-8a69-b3434f7f3e70
  modified: 2026-08-11T17:59:17.895Z
---

As of 2026-08-11, the MWL intake funnel (`components/intake/mwl/`) is not used on native — Evan accepted an Android-only silent-disable degradation on the intake state picker (BH-3797/#1032) on that basis: "The intake is not used on native today."

**Why it matters:** Native-only defects or degradations in intake screens are interim-acceptable; don't block PRs on them or raise them as merge risks. Web intake behavior remains the surface that matters. Related: [[pillars-not-member-visible]] — check feature visibility before flagging risk.
