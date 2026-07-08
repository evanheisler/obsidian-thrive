---
name: dont-reframe-asks-as-my-choices
description: Never describe my implementation choice as something the user asked for — state the ask and my chosen means separately
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3386b40e-8536-4fec-a976-2be83175ac1a
---

Evan asked to "eliminate the offset/ring" around a header avatar; I implemented it by opting out of iOS 26 liquid glass and then reported it as if opting out were the request.

**Why:** Conflating the user's goal with my chosen mechanism misattributes decisions and hides that an alternative might exist. The user owns the goal; I own (and must own up to) the means.

**How to apply:** When reporting a fix, phrase it as "you asked for X; I achieved it by Y (the only/best way because Z)". If the mechanism has side effects (e.g. losing a platform treatment), surface that as a consequence of my choice, not part of the ask.
