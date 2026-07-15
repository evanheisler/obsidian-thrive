---
name: cross-check-measurements
description: Never publish a screenshot/pixel measurement without validating the scale reference against a known platform constant
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3386b40e-8536-4fec-a976-2be83175ac1a
---

I told Evan the iOS liquid-glass header slot was ~50pt based on a screenshot measurement whose scale reference (an avatar I assumed rendered at 32pt) was itself wrong (NativeWind rem=14 made it 28pt). The real slot is 44pt — the standard UIKit bar metric. The wrong number drove a wrong size choice that Evan had to catch. See [[feedback-dont-reframe-asks-as-my-choices]] from the same feature.

**Why:** A measurement is only as good as its reference. Deriving a scale from my own rendered UI imports any bug in that UI into the measurement.

**How to apply:** Before asserting a measured size, cross-check against a platform constant or independent second reference (status bar height, screen width, UIKit's 44pt bar metric). If the measurement lands near a well-known platform value, prefer the platform value and say so.
